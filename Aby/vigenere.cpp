#include "libvigenere.h"
#include <iostream>

int main(int ac, const char *av[])
{
    // Encrypt or decrypt? Determined by command line switch
    bool enc = strcmp(av[1], "-e") == 0;

    // Initialize the MATLAB Compiler Runtime global state
    if (!mclInitializeApplication(NULL,0)) 
    {
        std::cerr << "Could not initialize the application properly."
                  << std::endl;
    	return -1;
    }

    // Initialize the Vigenere library
    if( !libvigenereInitialize() )
    {
        std::cerr << "Could not initialize the library properly."
                  << std::endl;
	return -1;
    }

    // Must declare all MATLAB data types after initializing the 
    // application and the library, or their constructors will fail.
    mwArray text(av[2]);
    mwArray key(av[3]);
    mwArray result;

    // Initialization succeeded. Encrypt or decrypt.

    if (enc == true)
    {
        // Encrypt the plaintext text with the key.
        // Request one output, pass in two inputs
        encrypt(1, result, text, key);
    }
    else
    {
        // Decrypt the ciphertext text with the key.
        // Request one output, pass in two inputs
        decrypt(1, result, text, key);
    }
    std::cout << result << std::endl;

    // Shut down the library and the application global state.
    libvigenereTerminate();
    mclTerminateApplication();
}
