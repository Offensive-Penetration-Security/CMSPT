#!/usr/bin/perl
use Digest::MD5  qw(md5_hex);
use Digest::SHA1  qw(sha1_hex);

# Author: @nu11secur1ty
# Date: 21/01/21
# Contact: @gmail.com
# Follow: nu11secur1ty.com

# Help

if(!$ARGV[7])
	{
		 print "\n\n###########################################";
		 print "\n# Multi CMS Hash Cracker v0.1 by localh0t #";
         	 print "\n###########################################";
		 print "\n\nUse: perl $0 -d [WORLDLIST FOLDER] -h [MD5 | SHA-1 HASH] -s [SALT | USERNAME] -c [CMS]\n";
		 print "Example: perl $0 -d /home/your_user/wordlists/ -h caef8544a8e65e23f67ab844d4866e8d -s uZ*qX -c IPB\n";
		 print "Example: perl $0 -d /home/your_user/wordlists/ -h dc4a27b25e3f780b89c165f931d6f85d5bd6e33e -s Administrator -c SMF\n\n";
		 print "Note: Worlists must end with .txt or .lst (or any extension)\n\n";	
		 print "Support:\n========\n";
		 print "VB     : md5_hex(md5_hex(password).salt)           | (vBulletin)\n";
		 print "SMF    : sha1_hex(user.password)                   | (Simple Machines Forum)\n";
		 print "IPB    : md5_hex(md5_hex(salt).md5_hex(password))  | (Invision Power Board)\n";
		 print "JOOMLA : md5_hex(password.salt)                    | (Joomla 1.x)\n\n";
		 exit(0);
	}


# Functions

sub ipb_cracker{
	my $hash = shift;
	my $salt = shift;
	my $dir  = shift;
	foreach $file (@FILES) {
	open(DICT,"<".$dir.$file) || die "\n[-] Error opening $file\n\n";
	print "[!] Using $file...\n";
			foreach $password(<DICT>) {
				$password=~s/\s|\n//;
				chomp($password);
				$cracked = md5_hex(md5_hex($salt).md5_hex($password));
				if ($cracked eq $hash) {
					return "[+] Hash cracked !: $password\n\n";
				}
			}
	print "[!] Nothing found with $file...\n\n";
	}
	return "\n[-] Password not found\n\n";
}

sub vb_cracker{
	my $hash = shift;
	my $salt = shift;
	my $dir  = shift;
	foreach $file (@FILES) {
	open(DICT,"<".$dir.$file) || die "\n[-] Error opening $file\n\n";
	print "[!] Using $file...\n";
			foreach $password(<DICT>) {
				$password=~s/\s|\n//;
				chomp($password);
				$cracked = md5_hex(md5_hex($password).$salt);
				if ($cracked eq $hash) {
					return "[+] Hash cracked !: $password\n\n";
				}
			}
	print "[!] Nothing found with $file...\n\n";
	}
	return "\n[-] Password not found\n\n";
}

sub smf_cracker{
	my $hash = shift;
	my $user = shift;
	my $dir  = shift;
	foreach $file (@FILES) {
	open(DICT,"<".$dir.$file) || die "\n[-] Error opening $file\n\n";
	print "[!] Using $file...\n";
			foreach $password(<DICT>) {
				$password=~s/\s|\n//;
				chomp($password);
				$cracked = sha1_hex($user.$password);
				if ($cracked eq $hash) {
					return "[+] Hash cracked !: $password\n\n";
				}
			}
	print "[!] Nothing found with $file...\n\n";
	}
	return "\n[-] Password not found\n\n";
}

sub joomla_cracker{
	my $hash = shift;
	my $salt = shift;
	my $dir  = shift;
	foreach $file (@FILES) {
	open(DICT,"<".$dir.$file) || die "\n[-] Error opening $file\n\n";
	print "[!] Using $file...\n";
			foreach $password(<DICT>) {
				$password=~s/\s|\n//;
				chomp($password);
				$cracked = md5_hex($password.$salt);
				if ($cracked eq $hash) {
					return "[+] Hash cracked !: $password\n\n";
				}
			}
	print "[!] Nothing found with $file...\n\n";
	}
	return "\n[-] Password not found\n\n";
}

my ($dir, $hash, $salt, $cms, $arg);

foreach $loop (@ARGV) {
	for ($loop) {
		/^-d$/ and do { $dir = $ARGV[($arg+1)]; last; };
		/^-h$/ and do { $hash = $ARGV[($arg+1)];  last; };
		/^-s$/ and do { $salt = $ARGV[($arg+1)]; last; };
		/^-c$/ and do { $cms = $ARGV[($arg+1)]; last; };
	}
	$arg++;
}


# Main

print "\n[!] Cracking $hash with $salt as username/salt...\n\n";

opendir(DIR, $dir) || die "\n[-] Folder not found\n\n";

while($file = readdir(DIR)) {
     if ($file ne '.' and $file ne '..') {
	$FILES[$clean] = $file;
	$clean++;
     }
}

for ($cms) {
  /^IPB$/    and do { $result = &ipb_cracker($hash,$salt,$dir); last; };
  /^VB$/     and do { $result = &vb_cracker($hash,$salt,$dir);  last; };
  /^SMF$/    and do { $result = &smf_cracker($hash,$salt,$dir); last; };
  /^JOOMLA$/ and do { $result = &joomla_cracker($hash,$salt,$dir); last; };
  /^.$/      and do { print "[-] CMS not available\n"; exit(0); last; };
}

print $result;

# Exit

close(DICT);
closedir(DIR);
exit(0);

__END__
