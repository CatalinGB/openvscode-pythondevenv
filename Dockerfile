FROM gitpod/openvscode-server:latest
USER root

ENV OPENVSCODE_SERVER_ROOT="/home/.openvscode-server"
ENV OPENVSCODE="${OPENVSCODE_SERVER_ROOT}/bin/openvscode-server"

RUN apt-get update && apt-get install -y python3 python3-pip iputils-ping python-is-python3 python3-packaging
RUN python3 -m pip install --upgrade pip

RUN python3 -mpip install smart_importer 
RUN python3 -mpip install beancount_portfolio_allocation
RUN python3 -mpip install beancount-plugins-metadata-spray
RUN python3 -mpip install beancount-interpolate
RUN python3 -mpip install iexfinance
RUN python3 -mpip install black
RUN python3 -mpip install werkzeug
RUN python3 -mpip install argh
RUN python3 -mpip install argcomplete
RUN python3 -mpip install pre-commit
RUN python3 -mpip install git+https://github.com/beancount/beanprice.git
RUN python3 -mpip install git+https://github.com/CatalinGB/beancounttools.git
RUN python3 -mpip install flake8
RUN python3 -mpip install babel
RUN python3 -mpip install beancount-import
RUN python3 -mpip install git+https://github.com/redstreet/fava_investor
RUN python3 -mpip install git+https://github.com/andreasgerstmayr/fava-income-reports.git
RUN python3 -mpip install nordigen
RUN python3 -mpip install thefuzz
RUN python3 -mpip install tariochbctools
RUN python3 -mpip install git+https://github.com/andreasgerstmayr/fava-dashboards.git

SHELL ["/bin/bash", "-c"]
RUN \
    # Direct download links to external .vsix not available on https://open-vsx.org/
    # The two links here are just used as example, they are actually available on https://open-vsx.org/
    urls=(\
        https://open-vsx.org/api/ms-python/python/2023.20.0/file/ms-python.python-2023.20.0.vsix \
        https://open-vsx.org/api/eamodio/gitlens/14.6.1/file/eamodio.gitlens-14.6.1.vsix \
    )\
    # Create a tmp dir for downloading
    && tdir=/tmp/exts && mkdir -p "${tdir}" && cd "${tdir}" \
    # Download via wget from $urls array.
    && wget "${urls[@]}" && \
    # List the extensions in this array
    exts=(\
        # From https://open-vsx.org/ registry directly
        gitpod.gitpod-theme \
        # From filesystem, .vsix that we downloaded (using bash wildcard '*')
        "${tdir}"/* \
    )\
    # Install the $exts
    && for ext in "${exts[@]}"; do ${OPENVSCODE} --install-extension "${ext}"; done
