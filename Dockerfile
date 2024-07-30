ARG TABBY_VERSION=v0.14.0
ARG TABBY_CUDA=122
ARG CUDA_VERSION=12.2.0-runtime-ubuntu22.04

FROM busybox AS downloader

ARG TABBY_VERSION
ARG TABBY_CUDA
ARG CUDA_VERSION

ENV TABBY_VERSION=$TABBY_VERSION
ENV TABBY_CUDA=$TABBY_CUDA

WORKDIR /
ADD https://github.com/TabbyML/tabby/releases/download/${TABBY_VERSION}/tabby_x86_64-manylinux2014-cuda${TABBY_CUDA}.zip /
RUN unzip /tabby_x86_64-manylinux2014-cuda${TABBY_CUDA}.zip \
    && chmod +x /dist/tabby_x86_64-manylinux2014-cuda${TABBY_CUDA}/llama-server \
  && chmod +x /dist/tabby_x86_64-manylinux2014-cuda${TABBY_CUDA}/tabby

FROM nvidia/cuda:${CUDA_VERSION}

ARG TABBY_VERSION
ARG TABBY_CUDA
ARG CUDA_VERSION

ENV TABBY_VERSION=$TABBY_VERSION
ENV TABBY_CUDA=$TABBY_CUDA
ENV CUDA_VERSION=$CUDA_VERSION

LABEL tabby.version="${TABBY_VERSION}"
LABEL tabby.cuda-version="${TABBY_CUDA}"
LABEL cuda.version="${CUDA_VERSION}"

COPY --from=downloader /dist/tabby_x86_64-manylinux2014-cuda${TABBY_CUDA}/tabby /usr/local/bin/
COPY --from=downloader /dist/tabby_x86_64-manylinux2014-cuda${TABBY_CUDA}/llama-server /usr/local/bin/
COPY entrypoint.sh /

VOLUME /tabby

ENTRYPOINT ["/entrypoint.sh"]
