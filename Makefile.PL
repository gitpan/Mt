require 5.005_03;  # need self-tie patch

use ExtUtils::MakeMaker;

WriteMakefile(
	      NAME         => 'Mt',
              VERSION      => '0.01',
	      dist         => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
);
