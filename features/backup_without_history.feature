Feature: Synchonising two folders for the first time
  As a cautious user
  I want to sync two folders
  So that I don't lose any of my work

Scenario: Syncing two empty directories
  Given a directory named "a"
  And a directory named "b"
  When I successfully run `dir_sync a b`
  Then the stdout should contain exactly:
  """

  """

Scenario: Syncing two non existant directories
  When I successfully run `dir_sync a b`
  Then the stdout should contain exactly:
  """

  """
  And a directory named "a" should exist
  And a directory named "b" should exist