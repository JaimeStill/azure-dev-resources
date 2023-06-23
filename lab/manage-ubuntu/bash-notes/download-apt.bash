(
    cd ./packages/deb/ ;
    PACKAGES="git nodejs"
    apt-get download \
        $(apt-cache depends \
            --recurse \
            --no-recommends \
            --no-suggests \
            --no-conflicts \
            --no-breaks \
            --no-replaces \
            --no-enhances \
            --no-pre-depends \
            ${PACKAGES} \
            | grep "^\w"
        )
)