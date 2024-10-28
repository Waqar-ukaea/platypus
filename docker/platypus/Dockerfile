# Build and test Platypus image
# Get base image
FROM alexanderianblair/platypus-deps:main

# By default four cores are used to compile
ARG compile_cores=4

# By default checkout main branch from aurora-multiphysics/platypus
ARG build_git_sha=main
ARG build_git_repo=aurora-multiphysics/platypus

# By default we install everything under /opt
ARG WORKDIR=opt

# By default, build without code coverage flags
ARG coverage=false

# Get Platypus
WORKDIR /$WORKDIR
RUN git clone https://github.com/$build_git_repo
WORKDIR /$WORKDIR/platypus
RUN git checkout $build_git_sha

# Build Platypus
WORKDIR /$WORKDIR/platypus
RUN make -j$compile_cores coverage=$coverage

# Build Platypus docs
WORKDIR /$WORKDIR/platypus
RUN make -j$compile_cores
RUN doxygen doc/content/doxygen/Doxyfile
WORKDIR /$WORKDIR/platypus/doc
RUN ./moosedocs.py build

# Test Platypus regression tests
WORKDIR /$WORKDIR/platypus 
RUN make test linkcoverage=$coverage

# Build Platypus unit tests
WORKDIR /$WORKDIR/platypus/unit
RUN make -j$compile_cores coverage=$coverage

# Test Platypus unit tests
WORKDIR /$WORKDIR/platypus/unit
RUN make test linkcoverage=$coverage

# Setup and Install Intel VTune (can be moved to deps image)
RUN apt-get update && apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl ca-certificates gpg-agent software-properties-common && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2023.PUB | gpg --dearmor | tee /usr/share/keyrings/intel-oneapi-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/intel-oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main " > /etc/apt/sources.list.d/oneAPI.list

RUN apt-get update && apt-get upgrade -y && \

# Run Intel VTune static code analysis on regression tests
WORKDIR /$WORKDIR/intel/oneapi
RUN . /opt/intel/oneapi/setvars.sh
WORKDIR /$WORKDIR/platypus
RUN mkdir -p /opt/platypus/vtune-results
WORKDIR /$WORKDIR/platypus/scripts
RUN run-vtune-analysis.sh 
