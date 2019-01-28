<?php
require 'core.php';
$image_name = $argv[1];
list($width, $height, $type, $attr) = getimagesize($image_name);
$image_ext_data = explode(".", $image_name);
$image_ext = $image_ext_data[sizeof($image_ext_data) - 1];

if ($height !== $width) {
    error_message("Please user square image");
}
if ($height < 500 || $width < 500) {
    error_message("Image resolution should be atleast 500x500");
}

$idle_size = $height > 500 ? 500/4 : $height / 4;
store_uploaded_image($image_name, $idle_size, $idle_size, "mipmap-mdpi",$type);
store_uploaded_image($image_name, $idle_size * 1.5, $idle_size * 1.5, "mipmap-hdpi",$type);
store_uploaded_image($image_name, $idle_size * 2, $idle_size * 2, "mipmap-xhdpi",$type);
store_uploaded_image($image_name, $idle_size * 3, $idle_size * 3, "mipmap-xxhdpi",$type);
store_uploaded_image($image_name, $idle_size * 4, $idle_size * 4, "mipmap-xxxhdpi",$type);

function store_uploaded_image($name, $new_img_width, $new_img_height, $dir_name,$type = 2)
{
    $image_ext_data = explode(".", $name);
    $image_ext = $image_ext_data[sizeof($image_ext_data) - 1];
    if (!is_dir("generated/" . $dir_name)) {
        mkdir("generated/" . $dir_name, 0755, true);
    }
    $target_file = $name;
    $image = new ResizeImage();
    $image->load($name);
    $image->resize($new_img_width, $new_img_height);
    $image->save("generated/" . $dir_name . "/launch_image." . $image_ext,$type);
    return $target_file;
}

function error_message($message)
{
    echo "\n=======================================\n";
    echo $message;
    echo "\n=======================================\n";
    exit();
}
//echo($image_ext);