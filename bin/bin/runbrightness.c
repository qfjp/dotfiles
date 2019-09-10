/*
 * http://www.tuxation.com/setuid-on-shell-scripts.html
 */
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <string.h>

int main(int argc, char** argv)
{
    if ( argc > 2 )
    {
        fprintf( stderr, "%s", "ERROR" );
        exit(1);
    }
    char* command = malloc( 255 * sizeof(char) );
    strcpy( command, "/home/dan/bin/brightness " );

    int i;
    for ( i = 1; i < argc; i++ )
    {
        strcat( command, argv[i] );
    }

    setuid( 0 );
    system( command );
    return 0;
}
