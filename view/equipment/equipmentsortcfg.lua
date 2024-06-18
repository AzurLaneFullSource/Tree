﻿local var0_0 = {
	index = {
		{
			spr = "index_all",
			tag = i18n("word_equipment_all")
		},
		{
			spr = "index_cannon",
			tag = i18n("word_equipment_small_cannon"),
			types = {
				EquipType.CannonQuZhu
			}
		},
		{
			spr = "index_cannon",
			tag = i18n("word_equipment_medium_cannon"),
			types = {
				EquipType.CannonQingXun,
				EquipType.CannonZhongXun
			}
		},
		{
			spr = "index_cannon",
			tag = i18n("word_equipment_big_cannon"),
			types = {
				EquipType.CannonZhanlie,
				EquipType.CannonZhongXun2
			}
		},
		{
			spr = "index_tarpedo",
			tag = i18n("word_equipment_warship_torpedo"),
			types = {
				EquipType.Torpedo
			}
		},
		{
			spr = "index_tarpedo",
			tag = i18n("word_equipment_submarine_torpedo"),
			types = {
				EquipType.SubmarineTorpedo
			}
		},
		{
			spr = "index_antiaircraft",
			tag = i18n("word_equipment_antiaircraft"),
			types = {
				EquipType.AntiAircraft,
				EquipType.RangedAntiAircraft
			}
		},
		{
			spr = "index_aircraft",
			tag = i18n("word_equipment_fighter"),
			types = {
				EquipType.FighterAircraft
			}
		},
		{
			spr = "index_aircraft",
			tag = i18n("word_equipment_bomber"),
			types = {
				EquipType.BomberAircraft
			}
		},
		{
			spr = "index_aircraft",
			tag = i18n("word_equipment_torpedo_bomber"),
			types = {
				EquipType.TorpedoAircraft
			}
		},
		{
			spr = "index_equip",
			tag = i18n("word_equipment_equip"),
			types = {
				EquipType.Equipment,
				EquipType.AntiSubAircraft,
				EquipType.Sonar,
				EquipType.Helicopter,
				EquipType.Goods
			}
		},
		{
			spr = "index_equip",
			tag = i18n("word_equipment_special"),
			types = {
				EquipType.SeaPlane,
				EquipType.Missile
			}
		}
	},
	skinIndex = {
		{
			types = {}
		},
		{
			types = {
				EquipType.CannonQuZhu,
				EquipType.CannonQingXun,
				EquipType.CannonZhongXun,
				EquipType.CannonZhanlie,
				EquipType.CannonZhongXun2
			}
		},
		{
			types = {
				EquipType.Torpedo,
				EquipType.SubmarineTorpedo
			}
		},
		{
			types = {
				EquipType.FighterAircraft,
				EquipType.TorpedoAircraft,
				EquipType.BomberAircraft,
				EquipType.SeaPlane
			}
		},
		{
			types = {
				EquipType.Equipment
			}
		}
	},
	campIndex = {
		{
			types = {}
		},
		{
			types = {
				Nation.US
			}
		},
		{
			types = {
				Nation.EN
			}
		},
		{
			types = {
				Nation.JP
			}
		},
		{
			types = {
				Nation.DE
			}
		},
		{
			types = {
				Nation.CN
			}
		},
		{
			types = {
				Nation.ITA
			}
		},
		{
			types = {
				Nation.SN
			}
		},
		{
			types = {
				Nation.FF,
				Nation.FR
			}
		},
		{
			types = {
				Nation.FF,
				Nation.FR
			}
		},
		{
			types = {
				Nation.LINK
			}
		},
		{
			types = {
				Nation.CM,
				Nation.MOT
			}
		}
	},
	propertyIndex = {
		{
			types = {}
		},
		{
			types = {
				AttributeType.Cannon
			}
		},
		{
			types = {
				AttributeType.Air
			}
		},
		{
			types = {
				AttributeType.Dodge
			}
		},
		{
			types = {
				AttributeType.AntiAircraft
			}
		},
		{
			types = {
				AttributeType.Torpedo
			}
		},
		{
			types = {
				AttributeType.Reload
			}
		},
		{
			types = {
				AttributeType.Durability
			}
		},
		{
			types = {
				AttributeType.AntiSub
			}
		},
		{
			types = {
				AttributeType.OxyMax
			}
		},
		{
			types = {
				AttributeType.Speed
			}
		},
		{
			types = {
				AttributeType.Hit
			}
		},
		{
			types = {
				AttributeType.Luck
			}
		}
	},
	ammoIndex1 = {
		{
			types = {}
		},
		{
			types = {
				EquipType.AmmoType_1
			}
		},
		{
			types = {
				EquipType.AmmoType_2
			}
		},
		{
			types = {
				EquipType.AmmoType_3
			}
		},
		{
			types = {
				EquipType.AmmoType_4,
				EquipType.AmmoType_5,
				EquipType.AmmoType_6,
				EquipType.AmmoType_7,
				EquipType.AmmoType_8,
				EquipType.AmmoType_9,
				EquipType.AmmoType_10
			}
		}
	},
	ammoIndex2 = {
		{
			types = {}
		},
		{
			types = {
				EquipType.AmmoType_4
			}
		},
		{
			types = {
				EquipType.AmmoType_5
			}
		}
	},
	sort = {
		{
			type = 1,
			spr = "sort_rarity",
			tag = i18n("word_equipment_rarity"),
			pages = {
				0,
				1,
				2
			},
			values = {
				"rarity",
				"nationality",
				"id",
				"level"
			}
		},
		{
			type = 2,
			spr = "sort_intensify",
			tag = i18n("word_equipment_intensify"),
			pages = {
				0,
				2
			},
			values = {
				"level",
				"rarity",
				"nationality",
				"id"
			}
		}
	},
	getWeight = function(arg0_1, arg1_1)
		if arg1_1 == "nationality" then
			return 100 - arg0_1:getConfig(arg1_1)
		else
			return arg0_1:getConfig(arg1_1)
		end
	end
}

function var0_0.sortFunc(arg0_2, arg1_2)
	local var0_2 = {
		function(arg0_3)
			return arg0_3.isSkin and 0 or 1
		end,
		function(arg0_4)
			if not arg0_4.isSkin then
				return 0
			else
				return (arg1_2 and -1 or 1) * (pg.equip_skin_template[arg0_4.id][arg0_2.value] or 0)
			end
		end,
		function(arg0_5)
			if not arg0_5.isSkin then
				return 0
			else
				return (arg1_2 and -1 or 1) * -arg0_5.id
			end
		end
	}

	for iter0_2, iter1_2 in ipairs(arg0_2.values) do
		table.insert(var0_2, function(arg0_6)
			if arg0_6.isSkin then
				return 0
			else
				return (arg1_2 and -1 or 1) * -var0_0.getWeight(arg0_6, iter1_2)
			end
		end)
	end

	return var0_2
end

return var0_0
