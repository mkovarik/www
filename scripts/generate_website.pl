use strict;
use FindBin qw($Bin);
use File::Basename;

generate_website();
sub generate_website {
    `mkdir -p $Bin/../dest/writing/`;
    my @posts = <$Bin/../content/writing/*.txt>;
    for my $post (@posts){
        generate_post($post);
    }
    generate_index();
    `rsync -avv $Bin/../content/static/ $Bin/../dest/static`;
    print("Done\n");
}
sub generate_post {
    my $post_name = shift;
    my $title = shift;
    $post_name = basename($post_name);
    $post_name =~ s/\.txt//;
    my $input_path = "$Bin/../content/writing/$post_name.txt";
    my $output_path = "$Bin/../dest/writing/$post_name.html";
    return if -e $output_path and stat($input_path) < stat($output_path);
    print "Generating $output_path ... \n";
    my $html_string = `kramdown --syntax-highlighter=rouge '$input_path'`;
    my $template_string = `cat $Bin/../content/posts/template.html`;
    $template_string =~ s/\{BODY\}/$html_string/;
    open(my $fh,'>', $output_path);
    print $fh $template_string;
}
sub generate_index {
    my $template_string = `cat $Bin/../content/templates/index.html`;
    my $output_path = "$Bin/../dest/index.html";
    open(my $fh, '>', $output_path);
    print $fh $template_string;
}
