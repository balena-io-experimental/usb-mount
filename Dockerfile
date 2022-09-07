FROM alpine:3.16.2

WORKDIR /app/usb-mount

# Install dependencies
RUN apk add --no-cache \
    findmnt \  
    grep \
    udev \
    util-linux 

COPY udev/usb.rules /etc/udev/rules.d/usb.rules
COPY scripts .
RUN chmod +x *

# Set up and listen for connections
CMD ["./start.sh"]
