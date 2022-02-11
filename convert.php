<?php

$root_dir = getcwd();

$slug = basename( $root_dir );

$readme = null;

if ( file_exists( $root_dir . '/README.md' ) ) {
	$readme = $root_dir . '/README.md';
} elseif ( file_exists( $root_dir . '/readme.txt' ) ) {
	$readme = $root_dir . '/readme.txt';
	die( "readme.txt currently not supported." );
} else {
	die( 1 );
}

$data = file_get_contents( $readme );

$newdata = convertScreenshots( $data, $slug );

file_put_contents( $readme, $newdata );

function convertScreenshots( $readme, $slug ) {

	if ( preg_match( '|## Screenshots\n(.*?)\n## [a-z]+|ism', $readme, $matches ) ) {

		preg_match_all( '|^[0-9]+\. (.*)$|im', $matches[1], $screenshots, PREG_SET_ORDER );

		$lastPrefix = $lastExtension = null;
		foreach ( $screenshots as $i => $screenshot ) {

			$screenshotUrl = getScreenshotUrl( $i + 1 );

			if ( $screenshotUrl ) {
				$readme = str_replace( $screenshot[0], '### ' . ( $i + 1 ) . ". {$screenshot[1]}\n\n![{$screenshot[1]}](" . $screenshotUrl . ")\n", $readme );
			} else {
				$readme = str_replace( $screenshot[0], '### ' . ( $i + 1 ) . ". {$screenshot[1]}\n\n", $readme );
			}
		}
	}

	return $readme;
}


function getScreenshotUrl( $index ) {

	$root_dir = getcwd();

	$slug = basename( $root_dir );

	if ( ! file_exists( $root_dir . '/.wordpress-org/screenshot-' . $index . '.png' ) ) {
		return null;
	}

	return 'https://ps.w.org/' . $slug . '/assets/screenshot-' . $index . '.png';

}
