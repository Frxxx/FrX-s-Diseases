-- Autor: FrX. Napisane od zera z dedykacją dla fulvous roleplay.
FDiseases = FDiseases or {}
FDiseases.Config = FDiseases.Config or {}
local config = FDiseases.Config

-- config --
config.InfectionInterval = 1800 -- Ilość czasu, po którym losowo wybrana osoba zostanie zarażona losowo wybraną chorobą.
config.InfectionPercent = { -- Nie zmieniaj pierwszego elementu, drugi element to szansa procentowa na zarażenie po upływie czasu do automatycznego zarażenia (linijka wyżej)
	{"cold", 75}, -- Nie zmeniaj stringa tylko liczbę.
	{"flu", 15},
	{"tuberculosis", 10},
	
}

-- Przeziębienie --
config.ColdInterval = 60 -- Czas, po którym następują objawy stałe (np. kaszel.)
config.ColdUpTime = 3600 -- czas, po którym choroba przechodzi sama.

-- grypa --
config.FluInterval = 20
config.FluUpTime = 3600

-- gruźlica --
config.TuberculosisInterval = 40
config.TuberculosisInterval2 = 900
config.TuberculosisUpTime = 2760