ARG purpose=base

FROM python:3.7-alpine AS base
LABEL maintainer="Jacob Tomlinson <jacob@tom.linson.uk>"
ENV flavour=base

WORKDIR /usr/src/app

# Copy source
COPY opsdroid opsdroid
COPY setup.py setup.py
COPY versioneer.py versioneer.py
COPY setup.cfg setup.cfg
COPY requirements*.txt ./
COPY README.md README.md
COPY MANIFEST.in MANIFEST.in

EXPOSE 8080

CMD ["opsdroid", "start"]


FROM base AS dev
ENV flavour=dev
RUN cat requirements_dev.txt >> requirements.txt


FROM base AS readthedocs
ENV flavour=rtd
RUN cat requirements_readthedocs.txt >> requirements.txt


FROM base AS test
ENV flavour=test
RUN cat requirements_test.txt >> requirements.txt


FROM ${purpose} AS final
RUN apk update \
&& apk add --no-cache gcc musl-dev git openssh-client \
&& pip3 install --upgrade pip \
&& pip3 install --no-cache-dir --no-use-pep517 . \
&& apk del gcc musl-dev

