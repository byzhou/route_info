#!/usr/bin/perl

use File::Basename ;
use integer ;
use warnings ;

$lefpre     = "lef\/" ;
$lefsuf     = "\.lef" ;
$lefcell    = $lefpre ;
$lefname    = $lefpre ;
$XorY       = 0 ;

$output     = "des\_ALLCELL.txt" ;
#write to file
open $writeFile , "+>" , $output or die "$output is not available!\n" ; 
print $output . " has been successfully opened!\n" ;

opendir ( DIR , $lefpre ) or die "$lefpre is not available!\n" ;
print $lefpre . " has been successfully opened!\n" ;
close ( DIR ) ;

#cellname creation
while ( $lefcell = readdir ( DIR ) ) {

    #Use a regular expression to ignore files beginning with a period
    next if ($lefcell =~ m/^\./ || $lefcell =~ m/^README\.md/ );

    #define cellname
    $lefname    = $lefpre . $lefcell ;

    #read file
    open $readFile , "<" , $lefname or die "$lefname is not available!\n" ;
    print $lefname . " has been successfully opened!\n" ;

    #write the name of the cell
    $lefcell        =~ s/$lefsuf//g ;
    print $writeFile $lefcell . "\t" ;

    #write info the cell
    while ( <$readFile> ) {
        if ( /SIZE*/ ) {
            print $writeFile "$&\t" ;
            #matching a floating number [-+]?([0-9]*\.[0-9]+|[0-9]+)
            while ( /[-+]?([0-9]*\.[0-9]+|[0-9]+)/g ) {
                if ( $XorY == 0 ) {
                    print $writeFile "X\t$&\t" ;
                    $XorY   = 1 ;
                } else {
                    print $writeFile "Y\t$&" ;
                    $XorY   = 0 ;
                }
            }
        }
    }
    #end of the one readFile
    print $writeFile "\n" ;

    close ( $readFile ) ;
}
close ( $writeFile ) ;

