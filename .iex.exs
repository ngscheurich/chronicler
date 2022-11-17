alias Chronicler.{Chronicle, Quest}

Chronicler.init()

quests = [
  %Quest{title: "Slay the The Lernaean Hydra", duration: 2000},
  %Quest{title: "Capture the Cretan Bull", duration: 1000, danger: 3},
  %Quest{title: "Retrieve the Belt of Hippolyta", duration: 10_000, danger: 2}
]

chronicle = spawn(fn -> Chronicle.loop(%Chronicle{quests: quests}) end)
