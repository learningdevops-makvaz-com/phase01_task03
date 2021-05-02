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
define( 'DB_NAME', 'wordpress' );

/** MySQL database username */
define( 'DB_USER', 'wordpress' );

/** MySQL database password */
define( 'DB_PASSWORD', 'P@$$w0rd!' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

define('FS_METHOD', 'direct');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */

define('AUTH_KEY',         '7a[8%*.+!L@T;T0ty>^iV]33140ec&9/5%IbW`4;$]1eW<Ya1< yD%lJ^I5+)cQ>');
define('SECURE_AUTH_KEY',  '_nx6H8k~9%1B3vIiw#R2@R%F.t!5WmZUnX[^}mza9`ta7@O@aRL0`wUpstO[1C^N');
define('LOGGED_IN_KEY',    'V;b-z5>b)vq.F4$0D9AfJ;Q<1fin|HO<LTZlPHSU`JJH!:pXW+(L:{M{^Okc|A$Y');
define('NONCE_KEY',        '6~$v4_0?yuV=U]hq*/x_)Z5cn?fGx6M}g6Ric5.6Ye-02 N-cvRUBSl_Aey8%wl)');
define('AUTH_SALT',        '&>R#FSlaag|xC1F!_x|Y4&z)(=bEeBc fclIV(lY+CDS-gy P[AH_tv: &(oBqJv');
define('SECURE_AUTH_SALT', 'x96V2l-*MDCq5hd)%2U[zKovLgLO,2WVC8GM:6),`dcJ3=-rVnDo+FJ$9$*3d&h<');
define('LOGGED_IN_SALT',   '/dp|D[ J_GTlvB-bai13O#*ni2.]/%S%;H^Wr*lIC#g%cDy_77bk~v_KSZF+bg,o');
define('NONCE_SALT',       '`vp9C:lez,MktT)tTr(T,6EUy<vzU|#,++=Z<XkMc}4hCM/oj#+Ac%KsR-F-XMu]');

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
