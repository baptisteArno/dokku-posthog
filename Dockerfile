ARG POSTHOG_VERSION="release-1.28.0"

FROM posthog/posthog:$POSTHOG_VERSION

EXPOSE 8000/tcp
