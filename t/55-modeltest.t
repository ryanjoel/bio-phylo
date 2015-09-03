#!/usr/bin/perl
use strict;
use Test::More 'no_plan';
use Bio::Phylo::Matrices::Matrix;
use Bio::Phylo::IO qw(parse);
use Bio::Phylo::Util::CONSTANT ':objecttypes';

eval { require Statistics::R };

 SKIP: {
     skip 'Statistics::R not installed', 5, if $@;

     use_ok( 'Bio::Phylo::Models::Substitution::Dna' );

     my $newick = '(((61394:0.026529,61412:0.024045):0.029924,(((61376:0.027806,(427616:0.007206,61452:0.006403):0.019284):0.004938,61378:0.021599):0.072517,61387:0.034333):0.016844 ):0.004777,(((((46842:0.046559,((339609:0.077901,(71111:0.197534,339614:0.062813):0.023736):0.045381,61388:0.039587):0.007007):0.004571,(((61455:0.045099,61454:0.022032):0.013633,((61383:0.033549,61384:0.033670):0.016087,((61402:0.054203,(9691:0.016299,339612:0.037517):0.018624):0.011996,61410:0.030455):0.002569):0.001614):0.001031,61408:0.066986):0.003614):0.006440,(29064:0.036669,(9690:0.045790,9694:0.044743):0.005749):0.031144):0.039766,(32536:0.105164,32538:0.033228):0.066086):0.005613,61405:0.042446):0.000000):0.000000;';
     
     my $project = parse(
         '-handle'     => \*DATA,
         '-format'     => 'fasta',
         '-type'       => 'dna',
         '-as_project' => 1,
    );
     
     my ($matrix) = @{ $project->get_items(_MATRIX_) };

     for my $seq ( @{ $matrix->get_entities } ) {
         $seq->set_generic('fasta_def_line'=>$seq->get_name);
     }

     my $tree = parse(
		 '-format' => 'newick',
		 '-string' => $newick,
	 )->first->resolve;
     
     ok(my $class = 'Bio::Phylo::Models::Substitution::Dna');
     my $est = $class->modeltest( '-matrix' => $matrix, '-tree' => $tree );
     isa_ok ( $est,  'Bio::Phylo::Models::Substitution::Dna');
     
     # test modeltest without tree
     $est = $class->modeltest( '-matrix' => $matrix );
     isa_ok ( $est,  'Bio::Phylo::Models::Substitution::Dna');
     ok ( $est->get_rate( 'A' => 'C' ) );    
}

__DATA__
>9690	   
CATGAGCTTTTGGTATTTTTCCAGTGTCTTTGTTCTAAATTCTGAAATTTTGTTTCAAGTATTTTTAATTGCATTGTTCTCAGAATTGCTTGAAGAGAAAAAAAAAATGAGTTGTGAAATATGTACTCTACCTGAGAATTGTTCGTAAGACAGTCACTAGTGAAATGTTAAATTTCCAAATTATTTTCCATAATACTCTTTCTTTAGCAGTCTAAAATGTTGGCCTACATATTCCATAAGTTTTGTGGGGTTTTTTTGTACTAAAATTTGAAGCACAGAAAAGTCAGGTAATCATTCAGAACTAAGGAAATTGGCCTTAATGGAGACAGTAAGGAGCACATCATTGAGCAG
>29064
CATGAGCTTTTGGTATTTTTCCAGTGTCTTTGTTCTAAATTCTGAAATTTTGTTTCAAGTATTTTTAATTGCATTGTTCTCAGAATTGCTTGAAGAGAAAAAAAAAATGAGTTGTGAAATATGTACTCTACCTGAGAATTGTTCGTAAGACAGTCACTAGTGAAATGTTAAATTTCCAAATTATTTTCCATAATACTCTTTCTTTAGCAGTCTAAAATGTTGGCCTACATATTCCATAAGTTTTGTGGGGTTTTTTTGTACTAAAATTTGAAGCACAGAAAAGTCAGGTAATCATTCAGAACTAAGGAAATTGGCCTTAATGGAGACAGTAAGGAGCACATCATTGAGCAG
>9694
CATGAGCTTTTGGTATTTTTCCAGTGTCTTTGTTCTAAATTCTGAAATTTTGTTTCAAGTATTTTTAATTGCATTGTTCTCAGAATTGCTTGAAGAGAAAAAAAAAATGAGTTGTGAAATATGTACTCTACCTGAGAATTGTTCGTAAGACAGTCACTAGTGAAATGTTAAATTTCCAAATTATTTTCCATAATACTCTTTCTTTAGCAGTCTAAAATGTTGGCCTACATATTCCATAAGTTTTGTGGGGTTTTTTTGTACTAAAATTTGAAGCACAGAAAAGTCAGGTAATCATTCAGAACTAAGGAAATTGGCCTTAATGGAGACAGTAAGGAGCACATCATTGAGCAG
>9691
CATGAGCTTTTGGTATTTTTCCAGTGTCTTTGTTCTAAATTCTGAAATTTTGTTTCAAGTATTTTTAATTGCATTGTTCTCAGAATTGCTTGAAGAGAAAAAAAAAATGAGTTGTGAAATATGTACTCTACCTGAGAATTGTTCGTAAGACAGTCACTAGTGAAATGTTAAATTTCCAAATTATTTTCCATAATACTCTTTCTTTAGCAGTCTAAAATGTTGGCCTACATATTCCATAAGTTTTGTGGGGTTTTTTTGTACTAAAATTTGAAGCACAGAAAAGTCAGGTAATCATTCAGAACTAAGGAAATTGGCCTTAATGGAGACAGTAAGGAGCACATCATTGAGCAG

