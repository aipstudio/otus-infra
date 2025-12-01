<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', '{{ cms_database }}' );

/** Database username */
define( 'DB_USER', '{{ cms_username }}' );

/** Database password */
define( 'DB_PASSWORD', '{{ cms_password }}' );

/** Database hostname */
define( 'DB_HOST', '{{ postgresql_cluster_lb_host }}:{{ postgresql_cluster_lb_port }}' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'lX&NV}v#+XaOKTj#H|}11o{Bp]Iv[3rP]D+y-C A~I>]!7q0*wriKr2q=%O-KUj|');
define('SECURE_AUTH_KEY',  '.wQ9?Vt6#f<U7WXJviWnaaA^QxrV5-[OkLp37;LsD9(r[E:-9G/?nkroAc,|2CEm');
define('LOGGED_IN_KEY',    'y-/A+MH!zSu&G9}+RPzu#H4090b<:C&|9Lu1-;/qY^8Df^&]Ez:BUL7wzPzG8U?b');
define('NONCE_KEY',        'Ng)gogBo{EfW~qZL*rFn}(w6QwPZl-rm| N=oL<arOZ6:T5l]~1se aEA(-izzUe');
define('AUTH_SALT',        '?gf~ALxoL3R(dV^G`x Mt(=7-%{c+e4P03|7?Vk<iaSrH*!xvcQVGxRTKxo*QBzG');
define('SECURE_AUTH_SALT', '@W9 J(WEa~U6wsZ3Q@ <$7TE+--62cOt;f$>`3uN0?;g*hps-!=&:0Vt]z#)YLG@');
define('LOGGED_IN_SALT',   '7~n4_6VL13~qj 5nW]*tTV WMcJa^|>r,N}[@||z7 -u-be(h^%_{M,+AE,>NL`B');
define('NONCE_SALT',       'mi-ul>d)hE,z9PtlB^@RL|EAR`Vc8?<QaL*x},[i#_b3kqLm2gf,:7^+}MmI ~e`');

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 *
 * At the installation time, database tables are created with the specified prefix.
 * Changing this value after WordPress is installed will make your site think
 * it has not been installed.
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/#table-prefix
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
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
