use Mt;
print "1..1\n";
$mt = Mt->new(-device=>'/dev/st0',
  	      DEBUG=>1);
print "not " unless $mt->command(-command=>'status') == 1;
print "ok 1\n";
