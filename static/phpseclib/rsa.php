<?php
include('Crypt/RSA.php');

class RSA extends Crypt_RSA
{
    private $public_key;
    private $private_key;
    
    function __construct($public_key, $private_key) 
	{
        $this->public_key = $public_key;
        $this->private_key = $private_key;
	    $path = get_include_path();
	    if (stripos($path, 'phpseclib') === FALSE)
	    {
	        set_include_path(get_include_path(). PATH_SEPARATOR . 'phpseclib');
	    }
	    parent::__construct();
	}

	function decryptor($cipher_text)
	{
		$this->setEncryptionMode(CRYPT_RSA_ENCRYPTION_PKCS1);
		$this->loadKey($this->private_key, CRYPT_RSA_PRIVATE_FORMAT_PKCS1);
	    $ciphers = new Math_BigInteger($cipher_text, 16);
	    return $this->decrypt($ciphers->toBytes());
	}
	
	function generate_keys()
	{
	    $this->setPublicKeyFormat(CRYPT_RSA_PUBLIC_FORMAT_RAW);
	    $key = $this->createKey(512);

	    $private_key = $key['privatekey'];
	    $n = new Math_BigInteger($key['publickey']['n'], 10);
	    $e = new Math_BigInteger($key['publickey']['e'], 10);

	    $public_key = $n->toHex();
	    $public_key_parity = $e->toHex();

	    $keys = array('private' => $private_key, 'public' => $public_key, 'parity' => $public_key_parity);
	    
	    return (object) $keys;
	}
}
