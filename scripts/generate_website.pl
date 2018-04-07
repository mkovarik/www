use strict;
use FindBin qw($Bin);
use File::Basename;
use YAML::XS;

generate_website();
sub generate_website {
    open(my  $blog_fh, "$Bin/../content/posts");
    my @categories = grep {-d "$Bin/../content/posts/$_" && /^\.{1,2}$/} readdir($blog_sdh);
    foreach my $category (@categories){
        `mkdir -p $Bin/../dest/posts/$category`;
        my @posts = <$category/*.txt>;
        foreach my $post (@posts){
            generate_post($category, basename($post));
        }
        generate_catindex($category);
    }
    generate_index();
    `rsync -avv $Bin/../content/static/ $Bin/../dest/static`;
}
sub generate_post {
    # Change post input to allow for .txt
    my $category = shift;
    my $post_name = shift;
    $post_name =~ s/\.txt//;
    my $input_path = "$Bin/../content/posts/$category/$post_name.txt";
    my $output_path = "$Bin/../dest/posts/$post_name.html";
    return if -e $output_path and stat($input_path) < stat($output_path);
    my $html_string = `kramdown --syntax-highlighter=rouge '$input_path'`;
    my $template_string = `cat $Bin/../content/posts/$category/template.html`;
    $template_string =~ s/\{BODY\}/$html_string/;
    open(my $fh,'>', $output_path);
    print $fh $template_string;
}
sub generate_catindex {
    return;
}
sub generate_index {
  return;
  my @posts = @_;
  my $index = '';
  for my $post (@posts) {
	  my $post_name = basename($post);
    $post_name =~ s/\.txt//;
    my $yyyy = substr $post_name, 0, 4;
    my $mm = substr $post_name, 4, 2;
    my $dd = substr $post_name, 6, 2;
    my $title = substr $post_name, 9;
    $title =~ s/_/ /g;
    my $date = "$yyyy-$mm-$dd";
    $index = $index . "<li><strong>$date</strong>: <a href=\"posts/$post_name.html\">$title</a></li>\n";
  }
  my $template_string = `cat $Bin/../content/template.html`;
  $template_string =~ s/\{INDEX\}/$index/;
  my $index_path = "$Bin/../dest/index.html";
  open(my $fh, '>', $index_path);
  print $fh $template_string;
}
