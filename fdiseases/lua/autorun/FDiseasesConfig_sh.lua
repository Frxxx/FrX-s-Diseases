-- Autor: FrX. Napisane z dedykacją dla Fulvous Roleplay. Author: FrX. Coded with dedication for Fulvous Roleplay.
FDiseases = FDiseases or {}
FDiseases.Config = FDiseases.Config or {}
local config = FDiseases.Config

-- config --
config.InfectionInterval = 1800 -- Czasu, po którym losowo wybrana osoba zostanie zarażona losowo wybraną chorobą. Time before, which random player will be infected with random disease
config.InfectionPercent = {
	{"cold", 75}, -- drugi element to szansa procentowa na zarażenie się chorobą, skrypt losuje jednego gracza co czas ustawiony w zmiennej wyżej.
	{"flu", 15}, -- second elemnt is chance of catching the diseases, the script is picking a random player, after the time set in Infection Interval.
	{"tuberculosis", 10},
	
}

-- Przeziębienie --
config.ColdInterval = 60 -- Czas, po którym następują objawy stałe (np. kaszel.). Interval for chronic symptoms.
config.ColdUpTime = 3600 -- czas, po którym choroba przechodzi sama. Time, after which disease automatically wears off.

-- grypa --
config.FluInterval = 20
config.FluUpTime = 3600

-- gruźlica --
config.TuberculosisInterval = 40
config.TuberculosisInterval2 = 900
config.TuberculosisUpTime = 2760
