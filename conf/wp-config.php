<?php
/**
 * Modificado por: Robson Vaamonde
 * Site: www.procedimentosemti.com.br
 * Facebook: facebook.com/ProcedimentosEmTI
 * Facebook: facebook.com/BoraParaPratica
 * YouTube: youtube.com/BoraParaPratica
 * Data de criação: 31/05/2016
 * Data de atualização: 30/07/2016
 * Versão: 0.4
 * Testado e homologado para a versão do Ubuntu Server 16.04 LTS x64
 * Kernel >= 4.4.x
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
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
/** O nome da base de dados do WordPress*/
define('DB_NAME', 'wordpress');

/** MySQL database username */
/** O nome do usuário da Base de Dados do MySQL para WordPress*/
define('DB_USER', 'wordpress');

/** MySQL database password */
/** A senha do usuário da Base de Dados do MySQL para WordPress*/
define('DB_PASSWORD', 'wordpress');

/** MySQL hostname */
/** Nome do Servidor do MySQL que é o Localhost*/
define('DB_HOST', 'localhost');

/** Database Charset to use in creating database tables. */
/** Configuração dos caracteres da Base de Dados, deixar o padrão*/
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
/** Configuração do Collate, deixar o padrão*/
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'put your unique phrase here');
define('SECURE_AUTH_KEY',  'put your unique phrase here');
define('LOGGED_IN_KEY',    'put your unique phrase here');
define('NONCE_KEY',        'put your unique phrase here');
define('AUTH_SALT',        'put your unique phrase here');
define('SECURE_AUTH_SALT', 'put your unique phrase here');
define('LOGGED_IN_SALT',   'put your unique phrase here');
define('NONCE_SALT',       'put your unique phrase here');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
