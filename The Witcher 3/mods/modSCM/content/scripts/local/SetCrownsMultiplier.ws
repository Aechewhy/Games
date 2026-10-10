// Set Crowns Multiplier 3.x - 2026, pMarK

class CrownsMultiplier {

	private var inGameConfigWrapper : CInGameConfigWrapper;

	public function Init()
	{
		inGameConfigWrapper = theGame.GetInGameConfigWrapper();

		// Zero is a valid multiplier; only an unset setting needs a default.
		if (inGameConfigWrapper.GetVarValue('SCM', 'mult') == "")
			inGameConfigWrapper.SetVarValue('SCM', 'mult', "1.0");
	}

	public function GetIsModOn() : bool
	{
		return inGameConfigWrapper.GetVarValue('SCM', 'switch');
	}

	public function GetModifiedValue(value: int) : int
	{
		var multiplier: float;
		multiplier = GetCrownMultiplier();

		return (int)((float)value * multiplier);
	}

	private function GetCrownMultiplier() : float
	{
		var value: float;

		value = StringToFloat(inGameConfigWrapper.GetVarValue('SCM', 'mult'));

		return value;
	}
}

@addField(CInventoryComponent)
private var setCrownsMultiplier : CrownsMultiplier;

@wrapMethod(CInventoryComponent)
function AddMoney(amount : int)
{
	if (amount > 0)
	{
		if (!setCrownsMultiplier)
		{
			setCrownsMultiplier = new CrownsMultiplier in this;
			setCrownsMultiplier.Init();
		}

		if (setCrownsMultiplier.GetIsModOn())
		{
			amount = setCrownsMultiplier.GetModifiedValue(amount);
			if (amount <= 0)
				return;
		}
	}

	wrappedMethod(amount);
}
