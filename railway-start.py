#!/usr/bin/env python3
"""
Railway-specific startup script for ClassQuiz
This avoids shell script line ending issues
"""

import os
import subprocess
import sys

def run_command(cmd, description):
    """Run a command and handle errors"""
    print(f"Running: {description}")
    try:
        result = subprocess.run(cmd, shell=True, check=True, capture_output=True, text=True)
        if result.stdout:
            print(result.stdout)
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error running {description}: {e}")
        if e.stdout:
            print(f"STDOUT: {e.stdout}")
        if e.stderr:
            print(f"STDERR: {e.stderr}")
        return False

def main():
    """Main startup function"""
    print("🚀 Starting ClassQuiz on Railway...")
    
    # Set default environment variables
    os.environ.setdefault('APP_MODULE', 'classquiz:app')
    os.environ.setdefault('WORKER_CLASS', 'uvicorn.workers.UvicornWorker')
    os.environ.setdefault('GUNICORN_CONF', '/app/gunicorn_conf.py')
    
    # Run database migrations
    print("📊 Running database migrations...")
    if not run_command("alembic upgrade head", "Database migrations"):
        print("⚠️  Database migration failed, but continuing...")
    
    # Start the application
    print("🌟 Starting Gunicorn server...")
    app_module = os.environ.get('APP_MODULE', 'classquiz:app')
    worker_class = os.environ.get('WORKER_CLASS', 'uvicorn.workers.UvicornWorker')
    gunicorn_conf = os.environ.get('GUNICORN_CONF', '/app/gunicorn_conf.py')
    
    cmd = f'gunicorn -k "{worker_class}" -c "{gunicorn_conf}" "{app_module}"'
    
    print(f"Executing: {cmd}")
    os.system(cmd)

if __name__ == "__main__":
    main()