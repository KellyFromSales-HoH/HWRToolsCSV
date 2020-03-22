namespace KellyTools
{
	[Hook]
	void GameModeConstructor(Campaign@ campaign)
	{


			// AddFunction("giveupgrades", GiveUpgradesCFunc);
			AddFunction("givebps", GiveBlueprintsCFunc);
			AddFunction("giveallbps", GiveAllBlueprintsCFunc);
			AddFunction("print_dyes", printDyesCFunc);
			AddFunction("print_trails", printtrailsCFunc);
			AddFunction("print_frames", printframesCFunc);
			AddFunction("print_item", printitemsCFunc);
			AddFunction("print_hcskills", printhcskillsCFunc);
	}

		// void GiveUpgradesCFunc()
		// 	{
		// 			auto record = GetLocalPlayerRecord();
		// 			auto player = GetLocalPlayer();
		// 			for (uint i = 0; i < g_shops.length(); i++)
		// 			{
		// 				shop = g_shops[i];
		// 				print(shop)
		// 				// for (uint i = 0; i < shop.m_upgrades.length(); i++)
		// 				// {
		// 				// 	print(shop.m_upgrades[i].m_id);
		// 				// 	// auto upgrade = m_shop.m_upgrades[i];
		// 				// }
		// 			}

		// 		// 	@ownedUpgrade = OwnedUpgrade();
		// 		// ownedUpgrade.m_id = upgrade.m_id;
		// 		// ownedUpgrade.m_idHash = upgrade.m_idHash;
		// 		// ownedUpgrade.m_level = step.m_level;
		// 		// @ownedUpgrade.m_step = step;
		// 		// record.upgrades.insertLast(ownedUpgrade);


		// 	}

		void GiveBlueprintsCFunc()
		{

			TownRecord@ town = null;
			auto gmMenu = cast<MainMenu>(g_gameMode);
			auto gmCampaign = cast<Campaign>(g_gameMode);
			auto player = GetLocalPlayer();
			//auto gm = cast<Town>(g_gameMode);

			player.m_record.itemForgeAttuned.removeRange(0, player.m_record.itemForgeAttuned.length());

			gmCampaign.m_townLocal.m_forgeBlueprints.removeRange(0, gmCampaign.m_townLocal.m_forgeBlueprints.length());

			if (gmMenu !is null)
				@town = gmMenu.m_town;
			else if (gmCampaign !is null)
				@town = gmCampaign.m_town;

			if (town is null)
			{
				PrintError("There is no town.");
				return;
			}

			for (uint i = 0; i < g_items.m_allItemsList.length(); i++)
			{
				auto item = g_items.m_allItemsList[i];
				//auto id = Resources::GetString(item.id);
					if (item.quality != ActorItemQuality::Epic && item.quality != ActorItemQuality::Legendary && item.hasBlueprints)
					{
						if (!item.canAttune)
						{
							GiveForgeBlueprintImpl(item, GetLocalPlayer(), true);
							print(Resources::GetString(item.name) + " - " + item.quality);
						}
						else
						{
						GiveForgeBlueprintImpl(item, GetLocalPlayer(), true);
						player.AttuneItem(item);
						print(Resources::GetString(item.name) +" - " + item.quality + " - " + GetItemAttuneCost(item));
						}
					}

			}

		}

		void printhcskillsCFunc()
		{

			print("name,class,cost,description");
			for (uint i = 0; i < g_hardcoreSkills.length(); i++)
			{

				auto hardcoreSkill = g_hardcoreSkills[i];
				//auto id = Resources::GetString(item.id);
						print(Resources::GetString(hardcoreSkill.m_name)+"," + hardcoreSkill.m_charClass +"," + hardcoreSkill.m_cost + "," + Resources::GetString(hardcoreSkill.m_description));
			}

		}

		void printitemsCFunc()
		{

			print("name,ID,quality,has bueprint,attuneable,attune cost,item cost,dlc,description");
			for (uint i = 0; i < g_items.m_allItemsList.length(); i++)
			{
				auto item = g_items.m_allItemsList[i];
				//auto id = Resources::GetString(item.id);
						print(Resources::GetString(item.name)+"," + item.id +"," + item.quality + "," + item.hasBlueprints + "," + item.canAttune + "," + GetItemAttuneCost(item) + "," + item.cost + "," + item.dlc + ","+ Resources::GetString(item.desc));
			}

		}


		void GiveAllBlueprintsCFunc()
		{

			TownRecord@ town = null;
			auto gmMenu = cast<MainMenu>(g_gameMode);
			auto gmCampaign = cast<Campaign>(g_gameMode);
			auto player = GetLocalPlayer();
			//auto gm = cast<Town>(g_gameMode);

			player.m_record.itemForgeAttuned.removeRange(0, player.m_record.itemForgeAttuned.length());

			gmCampaign.m_townLocal.m_forgeBlueprints.removeRange(0, gmCampaign.m_townLocal.m_forgeBlueprints.length());

			if (gmMenu !is null)
				@town = gmMenu.m_town;
			else if (gmCampaign !is null)
				@town = gmCampaign.m_town;

			if (town is null)
			{
				PrintError("There is no town.");
				return;
			}

			for (uint i = 0; i < g_items.m_allItemsList.length(); i++)
			{
				auto item = g_items.m_allItemsList[i];
				//auto id = Resources::GetString(item.id);
					GiveForgeBlueprintImpl(item, GetLocalPlayer(), true);
					player.AttuneItem(item);
					print("Gave & attuned blueprint \"" + Resources::GetString(item.name));

			}

		}

		int GetDyeCost(Materials::Dye@ dye)
	{

		switch (dye.m_quality)
		{
			case ActorItemQuality::Common: return 500;
			case ActorItemQuality::Uncommon: return 2500;
			case ActorItemQuality::Rare: return 10000;
		}
		return 10001;
	}

		void printDyesCFunc()
		{
			TownRecord@ town = null;

			auto gmMenu = cast<MainMenu>(g_gameMode);
			auto gmCampaign = cast<Campaign>(g_gameMode);

			if (gmMenu !is null)
				@town = gmMenu.m_town;
			else if (gmCampaign !is null)
				@town = gmCampaign.m_townLocal;

			if (town is null)
			{
				PrintError("There is no town.");
				return;
			}
			town.m_dyes.removeRange(0, town.m_dyes.length());
			print("name,cateogory,quality,default,cost,dlc,legacy points");

			for (uint i = 0; i < Materials::g_dyes.length(); i++)
			{
				auto dye = Materials::g_dyes[i];
					print(Resources::GetString(dye.m_name) +","+ Materials::GetCategoryName(dye.m_category) +","+ dye.m_quality +","+ dye.m_default +","+ GetDyeCost(dye) +","+ dye.m_dlc+ "," + dye.m_legacyPoints);
			}
		}

		void printtrailsCFunc()
		{
			TownRecord@ town = null;

			auto gmMenu = cast<MainMenu>(g_gameMode);
			auto gmCampaign = cast<Campaign>(g_gameMode);

			if (gmMenu !is null)
				@town = gmMenu.m_town;
			else if (gmCampaign !is null)
				@town = gmCampaign.m_townLocal;

			if (town is null)
			{
				PrintError("There is no town.");
				return;
			}
			print("name,legacy points");
			for (uint i = 0; i < PlayerTrails::g_trails.length(); i++)
			{
				auto trail = PlayerTrails::g_trails[i];
				{
					print(Resources::GetString(trail.m_name) + "," + trail.m_legacyPoints);
				}
			}
		}

		void printframesCFunc()
		{
			TownRecord@ town = null;

			auto gm = cast<Campaign>(g_gameMode);
			auto record = GetLocalPlayerRecord();

			auto arrInstances = PlayerFrame::Instances;
			arrInstances.sort(function(a, b) {
			return (a.m_legacyPoints < b.m_legacyPoints);
			});
		print("name,legacy points");
		for (uint i = 0; i < arrInstances.length(); i++)
		{
			auto frame = arrInstances[i];
				{
					print( Resources::GetString(frame.m_name) + "," + frame.m_legacyPoints);
				}
			}
		}

		void printgravestoneCFunc()
		{
			TownRecord@ town = null;

			auto gm = cast<Campaign>(g_gameMode);
			auto record = GetLocalPlayerRecord();

			auto arrInstances = PlayerCorpseGravestone::Instances;
			arrInstances.sort(function(a, b) {
			return (a.m_legacyPoints < b.m_legacyPoints);
			});
		print("name,legacy points");
		for (uint i = 0; i < arrInstances.length(); i++)
		{
			auto gravestone = arrInstances[i];
				{
					print(Resources::GetString(gravestone.m_name) + "," + gravestone.m_legacyPoints);
				}
			}
		}

		// void printpetskinsCFunc()
		// {
		// 	for (uint i = 0; i < Pets::g_defs.length(); i++)
		// 	{
		// 	auto petDef = Pets::g_defs[i];
		// 		//auto id = Resources::GetString(item.id);
		// 			print("petskin name= "  + Resources::GetString(petDef.m_skin.m_name) + " - £ = " + skin.m_cost + " - dlc =" + skin.m_requiredDlcs);

		// 	}

		// }
}