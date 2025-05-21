#include <rfb/rfbclient.h>
#include <iostream>
#include <cstdlib>
#include <cstring>

static char *password = nullptr;

char* getPassword(rfbClient* client) {
    return strdup(password);
}

int main(int argc, char **argv) {
    if (argc != 4) {
        std::cerr << "Usage: " << argv[0] << " <IP> <port> <password>" << std::endl;
        return 1;
    }

    const char* ip = argv[1];
    int port = std::atoi(argv[2]);
    password = argv[3];

    rfbClient* client = rfbGetClient(8, 3, 4);
    if (!client) {
        std::cerr << "rfbGetClient failed" << std::endl;
        return 1;
    }

    client->serverHost = strdup(ip);
    client->serverPort = port;

    client->canHandleNewFBSize = FALSE;
    client->MallocFrameBuffer = [](rfbClient* c) -> rfbBool {
        c->frameBuffer = (uint8_t*)calloc(c->width * c->height, 4);
        if (!c->frameBuffer) return FALSE;
        c->format.bitsPerPixel = 32;
        c->format.redShift = 16;
        c->format.greenShift = 8;
        c->format.blueShift = 0;
        c->format.trueColour = TRUE;
        c->format.redMax = 255;
        c->format.greenMax = 255;
        c->format.blueMax = 255;
        return TRUE;
    };

    client->GotFrameBufferUpdate = [](rfbClient* c, int x, int y, int w, int h) {
        std::cout << "FB update: " << w << "x" << h << " at " << x << "," << y << std::endl;
    };

    client->GetPassword = getPassword;

    if (!rfbInitClient(client, nullptr, nullptr)) {
        std::cerr << "Failed to initialize VNC client" << std::endl;
        return 1;
    }

    std::cout << "Connected. Receiving frames..." << std::endl;

    while (HandleRFBServerMessage(client)) {
        // Loop until connection breaks
    }

    std::cerr << "Connection closed." << std::endl;
    rfbClientCleanup(client);
    return 0;
}
