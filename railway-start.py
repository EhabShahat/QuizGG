#!/usr/bin/env python3
"""
Railway-specific startup script for ClassQuiz
This completely avoids shell script line ending issues
"""

import os
import subprocess
import sys
import time

def run_command(cmd, description, required=False):
    """Run a command and handle errors"""
    print(f"🔄 {description}...")
    try:
        result = subprocess.run(cmd, shell=True, check=True, capture_output=True, text=True)
        if result.stdout:
            print(result.stdout)
        print(f"✅ {description} completed successfully")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Error running {description}: {e}")
        if e.stdout:
            print(f"STDOUT: {e.stdout}")
        if e.stderr:
            print(f"STDERR: {e.stderr}")
        if required:
            print(f"💥 {description} is required, exiting...")
            sys.exit(1)
        else:
            print(f"⚠️  {description} failed, but continuing...")
        return False

def check_environment():
    """Check if required environment variables are set"""
    print("🔍 Checking environment variables...")
    
    required_vars = ['SECRET_KEY', 'DATABASE_URL']
    missing_vars = []
    
    for var in required_vars:
        if not os.environ.get(var):
            missing_vars.append(var)
    
    if missing_vars:
        print(f"❌ Missing required environment variables: {', '.join(missing_vars)}")
        print("Please set these variables in Railway dashboard and redeploy.")
        return False
    
    print("✅ Required environment variables are set")
    return True

def wait_for_database():
    """Wait for database to be available"""
    print("⏳ Waiting for database to be ready...")
    max_attempts = 30
    for attempt in range(max_attempts):
        try:
            # Try to connect to database
            result = subprocess.run(
                "python -c \"import psycopg2; import os; psycopg2.connect(os.environ['DATABASE_URL'])\"",
                shell=True, 
                check=True, 
                capture_output=True, 
                text=True,
                timeout=10
            )
            print("✅ Database is ready!")
            return True
        except (subprocess.CalledProcessError, subprocess.TimeoutExpired):
            if attempt < max_attempts - 1:
                print(f"⏳ Database not ready, attempt {attempt + 1}/{max_attempts}, waiting 2 seconds...")
                time.sleep(2)
            else:
                print("❌ Database connection timeout, but continuing...")
                return False
    return False

def main():
    """Main startup function"""
    print("🚀 Starting ClassQuiz on Railway...")
    print("=" * 50)
    
    # Check environment variables
    if not check_environment():
        print("💡 Tip: Set environment variables in Railway dashboard → Your Service → Variables")
        time.sleep(10)  # Give time to read the message
        sys.exit(1)
    
    # Set default environment variables
    os.environ.setdefault('APP_MODULE', 'classquiz:app')
    os.environ.setdefault('WORKER_CLASS', 'uvicorn.workers.UvicornWorker')
    os.environ.setdefault('GUNICORN_CONF', '/app/gunicorn_conf.py')
    os.environ.setdefault('HOST', '0.0.0.0')
    os.environ.setdefault('PORT', '80')
    
    print(f"📦 App Module: {os.environ.get('APP_MODULE')}")
    print(f"👷 Worker Class: {os.environ.get('WORKER_CLASS')}")
    print(f"⚙️  Config File: {os.environ.get('GUNICORN_CONF')}")
    
    # Wait for database
    wait_for_database()
    
    # Run database migrations
    print("📊 Running database migrations...")
    run_command("alembic upgrade head", "Database migrations", required=False)
    
    # Start the application
    print("🌟 Starting Gunicorn server...")
    app_module = os.environ.get('APP_MODULE')
    worker_class = os.environ.get('WORKER_CLASS')
    gunicorn_conf = os.environ.get('GUNICORN_CONF')
    host = os.environ.get('HOST', '0.0.0.0')
    port = os.environ.get('PORT', '80')
    
    # Use exec to replace the Python process with Gunicorn
    cmd = [
        'gunicorn',
        '-k', worker_class,
        '-c', gunicorn_conf,
        '--bind', f'{host}:{port}',
        app_module
    ]
    
    print(f"🚀 Executing: {' '.join(cmd)}")
    print("=" * 50)
    
    # Replace current process with gunicorn
    os.execvp('gunicorn', cmd)

if __name__ == "__main__":
    main()