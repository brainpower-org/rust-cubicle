FROM brainpower/cubicle:code-1.939-share-1.0.125

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates curl file build-essential autoconf automake autotools-dev libtool xutils-dev expect && rm -rf /var/lib/apt/lists/*

# Check for nightly builds with wanted components via https://hub.docker.com/r/brainpower/rust-component-history, 
# e.g. via docker run brainpower/rust-component-history --target x86_64-unknown-linux-gnu
# * rls
# * clippy
# * rustfmt
RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly-2019-03-23 -y

ENV PATH=/root/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV CARGO_TARGET_DIR=/root/target

RUN rustup component add rls clippy rustfmt rust-analysis rust-src

RUN cargo install cargo-watch
RUN cargo install cargo-add

ADD rls-build /usr/bin/rls-build
RUN ext install rust-lang.rust 0.6.1
RUN ext install serayuzgur.crates 0.4.2
RUN ext install bungcip.better-toml 0.3.2

RUN apt-get update && apt-get install --no-install-recommends -y lldb
RUN code-server --install-extension vadimcn.vscode-lldb 1.2.2

RUN ln -s /root/.rustup/toolchains/nightly-2019-03-23-x86_64-unknown-linux-gnu/ /root/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu
