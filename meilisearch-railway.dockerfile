FROM getmeili/meilisearch:v0.28.0

ENV MEILI_NO_ANALYTICS=true

EXPOSE 7700

CMD ["meilisearch"]