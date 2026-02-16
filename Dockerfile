FROM scratch
COPY stress-ng /stress-ng
ENTRYPOINT ["/stress-ng"]
