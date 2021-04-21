<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wp_db' );

/** MySQL database username */
define( 'DB_USER', 'wp_user' );

/** MySQL database password */
define( 'DB_PASSWORD', 'wp_password' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY', 't M&L&56FEZS@I$(aZ9?,R7O!pBQ~q=-A[qb]zA-YD;2;r`64nr+fTTaC+/9)VC|');
define('SECURE_AUTH_KEY', 'IP,~&5<3`d8*]gIKhN/Up/{I:P{rbGsFOvn&2wY|gcKu@%{l#$M/RHa|5iRagn/2');
define('LOGGED_IN_KEY', 'u-dA~MEE&X@|}2OK,-n3v,vgoe$NJCWl!NOIo<Sc9H7b+CI{.v-}>xTG8^b~|qi!');
define('NONCE_KEY', '>6Q+*Kp&~vA|DAkC,1e-l&J3n=oS##-qFl./G!H_d|i`-^H5Z7A`Ioh8c}k$/$Ct');
define('AUTH_SALT', '}MfxME5xrgNe5|$oN5 K#tiiaR^JK|:VV[k&I=%XcR}#Y+7~1^@_D:p<$VyUZ4da');
define('SECURE_AUTH_SALT', '%&+MZ|H@1Xx|+4<P9!tWj)Vf04</hg-*f9+ab:c9%qoOvuUVw }cRcDhDw/K@]+s');
define('LOGGED_IN_SALT', 'OeR/5<eg:*+1$m%}{FW !D[WxUtcS6rKI*E;2hwCs?~C!UkAd-IT%?.fnbqz@rSr');
define('NONCE_SALT', 'j.ST.MY~0<Ws!Fe:lw%fy6K*Eh$mwQ7Z4oTM7w!zH:[]L1#Hz6CIf$:Z9n5}yFHQ');
/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
