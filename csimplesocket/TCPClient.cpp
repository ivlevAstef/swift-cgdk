#include "ActiveSocket.h"

#ifdef __cplusplus
extern "C" {
#endif
	/// Для упрощения своей жизни, будем считать что у нас один сокет.
	CActiveSocket sockets[4];
	int socketIndex = 0;
	
	// -1 failed 0 and great success - index
	int16 css_open(const char* host, int32 port) {
		sockets[socketIndex].Initialize();
		sockets[socketIndex].DisableNagleAlgoritm();
		
		if (!sockets[socketIndex].Open((const uint8*)host, (int16)port)) {
			return -1;
		}
		
		return socketIndex++;
	}
	
	void css_close(int16 index) {
		sockets[index].Close();
	}
	
	void css_send(int16 index, const int8* buf, uint32 bytesToSend) {
		unsigned int offset = 0;
		int sentByteCount;
		
		while (offset < bytesToSend && (sentByteCount = sockets[index].Send((const uint8*)&buf[offset], bytesToSend - offset)) > 0) {
			offset += sentByteCount;
		}
		
		if (offset != bytesToSend) {
			exit(10013);
		}
	}
	
	void css_read(int16 index, int8* buf, uint32 bytesToReceive) {
		unsigned int offset = 0;
		int receivedByteCount;
		
		while (offset < bytesToReceive && (receivedByteCount = sockets[index].Receive(bytesToReceive - offset)) > 0) {
			memcpy(&buf[offset], sockets[index].GetData(), receivedByteCount);
			offset += receivedByteCount;
		}
		if (offset != bytesToReceive) {
			exit(10012);
		}
	}
	
#ifdef __cplusplus
}
#endif
