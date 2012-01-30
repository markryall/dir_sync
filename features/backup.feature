Feature: Synchonising folders
  As a practical, intelligent and charismatic person
  I want to synchronise folders
  So that I can keep multiple backup copies of my work

Scenario: Syncing two empty directories
  Given a directory named "a"
  And a directory named "b"
  When I successfully run `dir_sync test a b`
  Then the stdout should contain exactly:
  """

  """

Scenario: Syncing two non existant directories
  When I successfully run `dir_sync test a b`
  Then the stdout should contain exactly:
  """

  """
  And a directory named "a" should exist
  And a directory named "b" should exist

Scenario: Syncing a single file from left to right
  Given the file system:
  | path         | time |
  | a/readme.txt | 1000 |
  When I successfully run `dir_sync test a b`
  Then the stdout should contain exactly:
  """
  cp -p "a/readme.txt" "b/readme.txt"

  """

Scenario: Syncing a single file from right to left
  Given the file system:
  | path         | time |
  | b/readme.txt | 1000 |
  When I successfully run `dir_sync test a b`
  Then the stdout should contain exactly:
  """
  cp -p "b/readme.txt" "a/readme.txt"

  """

Scenario: Do nothing when files are already in sync with history
  Given the file system:
  | path         | time |
  | a/readme.txt | 1000 |
  | b/readme.txt | 1000 |
  And past synchronisation history:
  | path         | time |
  | readme.txt   | 1000 |
  When I successfully run `dir_sync test a b`
  Then the stdout should contain exactly:
  """

  """
  And the synchronisation history should be:
  | path         | time |
  | readme.txt   | 1000 |  

Scenario: Detecting a deletion from past history
  Given the file system:
  | path         | time |
  | b/readme.txt | 1000 |
  And past synchronisation history:
  | path         | time |
  | readme.txt   | 1000 |
  When I successfully run `dir_sync test a b`
  Then the stdout should contain exactly:
  """
  rm "b/readme.txt"

  """
 
 Scenario: Delete all copies of a file that has been removed
   Given the file system:
   | path         | time |
   | a/readme.txt | 1000 |
   | b/readme.txt | 1000 |
   And past synchronisation history:
   | path         | time |
   | readme.txt   | 1000 |
   When I successfully run `dir_sync test a b c`
   Then the stdout should contain exactly:
   """
   rm "a/readme.txt"
   rm "b/readme.txt"

   """
 