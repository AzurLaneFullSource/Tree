ResPathSupport = {}

local var0_0 = ResPathSupport

var0_0.ConstPath = {}
var0_0.ConstPath.BG = {}
var0_0.ConstPath.BG.Base = "bg"
var0_0.ConstPath.BG.CommonBG = "commonbg"
var0_0.ConstPath.BG.ShipRarityBG = "bg/star_level_bg_%s%s"
var0_0.ConstPath.BG.ShipRarityUI = "ui/star_level_bg_%s%s"
var0_0.ConstPath.BG.ShipRarityEffect = "ui/al_bg02_%s"
var0_0.ConstPath.BG.ShipCard = "bg/star_level_card_%s"
var0_0.ConstPath.BG.ShipBGFixList = {
	"",
	"_0",
	"_1"
}
var0_0.ConstPath.BG.LoadingBGList = {
	"loadingbg",
	"loadingbg_hx"
}
var0_0.ConstPath.BG.LoadingBG = "loadingbg"
var0_0.ConstPath.Sound = {}
var0_0.ConstPath.Sound.Default = "cue/%s.b"
var0_0.ConstPath.Sound.BGM = "cue/bgm-%s.b"
var0_0.ConstPath.Painting = {}
var0_0.ConstPath.Painting.Base = "painting/%s%s"
var0_0.ConstPath.Painting.FixList = {
	"",
	"_blueprint",
	"_ex",
	"_hx",
	"_n",
	"_n_ex",
	"_n_hx",
	"_n_rw",
	"_pt_hx",
	"_rank",
	"_shophx",
	"_wjz",
	"_wjz_hx"
}
var0_0.ConstPath.Painting.ShopFixList = {
	"",
	"_hx",
	"_shophx"
}
var0_0.ConstPath.PaintingFace = {}
var0_0.ConstPath.PaintingFace.Base = "paintingface/%s%s"
var0_0.ConstPath.PaintingFace.FixList = {
	"",
	"_hx"
}
var0_0.ConstPath.PaintingShipYardIcon = {}
var0_0.ConstPath.PaintingShipYardIcon.Base = "shipyardicon/%s%s"
var0_0.ConstPath.PaintingShipYardIcon.FixList = {
	"",
	"_hx"
}
var0_0.ConstPath.PaintingSquareIcon = {}
var0_0.ConstPath.PaintingSquareIcon.Base = "squareicon/%s%s"
var0_0.ConstPath.PaintingSquareIcon.FixList = {
	"",
	"_hx"
}
var0_0.ConstPath.PaintingHeroHrzIcon = {}
var0_0.ConstPath.PaintingHeroHrzIcon.Base = "herohrzicon/%s%s"
var0_0.ConstPath.PaintingHeroHrzIcon.FixList = {
	"",
	"_hx"
}
var0_0.ConstPath.Live2D = {}
var0_0.ConstPath.Live2D.Base = "live2d/%s%s"
var0_0.ConstPath.Live2D.FixList = {
	"",
	"_hx"
}
var0_0.ConstPath.SpinePainting = {}
var0_0.ConstPath.SpinePainting.Base = "spinepainting/%s%s"
var0_0.ConstPath.SpinePainting.FixList = {
	"",
	"_hx"
}
var0_0.ConstPath.SpineChar = {}
var0_0.ConstPath.SpineChar.Base = "char/%s%s"
var0_0.ConstPath.SpineChar.FixList = {
	"",
	"_hx",
	"_l",
	"_r"
}
var0_0.ConstPath.SpineQIcon = {}
var0_0.ConstPath.SpineQIcon.Base = "qicon/%s%s"
var0_0.ConstPath.SpineQIcon.FixList = {
	"",
	"_hx",
	"_l",
	"_r"
}
var0_0.ConstPath.SpineModel = {}
var0_0.ConstPath.SpineModel.Base = "shipmodels/%s%s"
var0_0.ConstPath.SpineModel.FixList = {
	"",
	"_hx",
	"_l",
	"_r"
}
var0_0.ConstPath.Ship = {}
var0_0.ConstPath.Ship.Rarity = {}
var0_0.ConstPath.Ship.Rarity.NewShipBG = "newshipbg/bg_%s"
var0_0.ConstPath.Ship.Rarity.EffectDesign = "raritydesign/%s"
var0_0.ConstPath.Ship.Rarity.EffectMeta = "raritymeta/%s"
var0_0.ConstPath.Ship.Rarity.ShipRarity = "shiprarity/%s%s%s"
var0_0.ConstPath.Ship.Rarity.ShipRarityFixList1 = {
	"",
	"0",
	"1"
}
var0_0.ConstPath.Ship.Rarity.ShipRarityFixList2 = {
	"m",
	"s"
}
var0_0.ConstPath.Ship.Rarity.GetRole = "ui/getrole_%s%s"
var0_0.ConstPath.Ship.Rarity.GetRoleFixList = {
	"",
	"_1",
	"_2"
}
var0_0.ConstPath.Ship.Nation = {}
var0_0.ConstPath.Ship.Nation.Prints = "prints/%s%s"
var0_0.ConstPath.Ship.Nation.PrintsFixList = {
	"_0"
}
var0_0.ConstPath.Commander = {}
var0_0.ConstPath.Commander.CommanderHrz = "commanderhrz"
var0_0.ConstPath.Commander.CommanderSkillIcon = "commanderskillicon"
var0_0.ConstPath.Equipment = {}
var0_0.ConstPath.Equipment.Equip = "equips"
var0_0.ConstPath.LevelMap = "levelmap"
var0_0.ConstPath.ChapterPic = "chapter/pic"
var0_0.ConstPath.Enemies = "enemies"
var0_0.ConstPath.StrategyIcon = "strategyicon"
var0_0.ConstPath.FurnitureIcon = "furnitureicon"
var0_0.ConstPath.UI = {}
var0_0.ConstPath.UI.Base = "ui"
var0_0.ConstPath.UI.Atlas = "_atlas"
var0_0.ConstPath.UI.LivingAreaCover = "livingareacover"
var0_0.ConstPath.UI.ActivityBanner = "activitybanner"
var0_0.ConstPath.UI.LinkButton = "linkbutton"
var0_0.ConstPath.UI.ShipSkillIcon = "skillicon"
var0_0.ConstPath.UI.Effect = "effect"
var0_0.ConstPath.UI.ShipModelBuliding = "ui/shipmodelbuliding"
var0_0.ConstPath.UI.BuildPainting = "ui/buildpainting"
var0_0.ConstPath.UI.IconFrame = "iconframe"

function var0_0.MergeLuaArr(...)
	local var0_1 = {}

	for iter0_1, iter1_1 in pairs({
		...
	}) do
		if iter1_1 then
			for iter2_1 = 1, #iter1_1 do
				var0_1[#var0_1 + 1] = iter1_1[iter2_1]
			end
		end
	end

	return var0_1
end

function var0_0.UniqueLuaArr(arg0_2)
	local var0_2 = {}
	local var1_2 = {}

	if arg0_2 then
		for iter0_2 = 1, #arg0_2 do
			local var2_2 = arg0_2[iter0_2]

			if var2_2 and var2_2 ~= "" and not var1_2[var2_2] then
				var1_2[var2_2] = true
				var0_2[#var0_2 + 1] = var2_2
			end
		end
	end

	return var0_2
end

function var0_0.CombinePath(...)
	local var0_3 = {
		...
	}

	return table.concat(var0_3, "/")
end

function var0_0.GetSoundResList(arg0_4)
	local var0_4 = {
		var0_0.ConstPath.Sound.Default,
		var0_0.ConstPath.Sound.BGM
	}
	local var1_4 = {}

	if arg0_4 and #arg0_4 > 0 then
		_.each(var0_4, function(arg0_5)
			table.insert(var1_4, string.format(arg0_5, arg0_4))
		end)
	end

	return var1_4
end

function var0_0.GetShipRarityBgList(arg0_6)
	local var0_6 = pg.ship_data_statistics[arg0_6].rarity
	local var1_6 = {
		var0_6,
		var0_6 + 1
	}
	local var2_6 = var0_0.ConstPath.BG.ShipBGFixList
	local var3_6 = {
		var0_0.ConstPath.BG.ShipRarityBG,
		var0_0.ConstPath.BG.ShipRarityUI
	}
	local var4_6 = {}

	_.each(var3_6, function(arg0_7)
		_.each(var1_6, function(arg0_8)
			local var0_8 = shipRarity2bgPrint(arg0_8, false, false)

			_.each(var2_6, function(arg0_9)
				table.insert(var4_6, string.lower(string.format(arg0_7, var0_8, arg0_9)))
			end)
		end)
	end)
	_.each(var1_6, function(arg0_10)
		if arg0_10 > 2 then
			table.insert(var4_6, string.lower(string.format(var0_0.ConstPath.BG.ShipRarityEffect, arg0_10 - 1)))
		end
	end)

	return var4_6
end

function var0_0.GetShipSkinBgList(arg0_11)
	local var0_11 = pg.ship_skin_template[arg0_11]
	local var1_11 = {
		var0_11.bg_sp,
		var0_11.bg,
		var0_11.rarity_bg
	}
	local var2_11 = {
		var0_0.ConstPath.BG.ShipRarityBG,
		var0_0.ConstPath.BG.ShipRarityUI
	}
	local var3_11 = {}

	_.each(var2_11, function(arg0_12)
		_.each(var1_11, function(arg0_13)
			if arg0_13 and #arg0_13 > 0 then
				table.insert(var3_11, string.lower(string.format(arg0_12, arg0_13, "")))
			end
		end)
	end)

	return var3_11
end

function var0_0.GetSkillIconList(arg0_14)
	local var0_14 = var0_0.ConstPath.UI.ShipSkillIcon
	local var1_14 = pg.ship_data_template[arg0_14].buff_list_display
	local var2_14 = {}

	_.each(var1_14, function(arg0_15)
		local var0_15 = getSkillConfig(arg0_15)
		local var1_15 = tostring(var0_15.icon)

		if var1_15 and #var1_15 > 0 then
			local var2_15 = var0_0.CombinePath(var0_14, var1_15)
			local var3_15 = string.lower(var2_15)

			table.insert(var2_14, var3_15)
		end
	end)

	return var2_14
end

function var0_0.GetSpineCharListByPrefabName(arg0_16)
	local var0_16 = var0_0.ConstPath.SpineChar.Base
	local var1_16 = var0_0.ConstPath.SpineChar.FixList
	local var2_16 = {}

	if arg0_16 and #arg0_16 > 0 then
		_.each(var1_16, function(arg0_17)
			table.insert(var2_16, string.lower(string.format(var0_16, arg0_16, arg0_17)))
		end)
	end

	return var2_16
end

function var0_0.GetSpineQIconListByPrefabName(arg0_18)
	local var0_18 = var0_0.ConstPath.SpineQIcon.Base
	local var1_18 = var0_0.ConstPath.SpineQIcon.FixList
	local var2_18 = {}

	if arg0_18 and #arg0_18 > 0 then
		_.each(var1_18, function(arg0_19)
			table.insert(var2_18, string.lower(string.format(var0_18, arg0_18, arg0_19)))
		end)
	end

	return var2_18
end

function var0_0.GetSpineModelsByPrefabName(arg0_20)
	local var0_20 = var0_0.ConstPath.SpineModel.Base
	local var1_20 = var0_0.ConstPath.SpineModel.FixList
	local var2_20 = {}

	if arg0_20 and #arg0_20 > 0 then
		_.each(var1_20, function(arg0_21)
			table.insert(var2_20, string.lower(string.format(var0_20, arg0_20, arg0_21)))
		end)
	end

	return var2_20
end

function var0_0.GetPaintingListByPaintingName(arg0_22)
	local var0_22 = var0_0.ConstPath.Painting.Base
	local var1_22 = var0_0.ConstPath.Painting.FixList
	local var2_22 = {}

	if arg0_22 and #arg0_22 > 0 then
		_.each(var1_22, function(arg0_23)
			local var0_23 = string.lower(string.format(var0_22, arg0_22, arg0_23))

			table.insert(var2_22, var0_23)
		end)
	end

	return var2_22
end

function var0_0.GetShopPaintingListByPaintingName(arg0_24)
	local var0_24 = var0_0.ConstPath.Painting.Base
	local var1_24 = var0_0.ConstPath.Painting.ShopFixList
	local var2_24 = {}

	if arg0_24 and #arg0_24 > 0 then
		_.each(var1_24, function(arg0_25)
			local var0_25 = string.lower(string.format(var0_24, arg0_24, arg0_25))

			table.insert(var2_24, var0_25)
		end)
	end

	return var2_24
end

function var0_0.GetPaintingFaceListByPaintingName(arg0_26)
	local var0_26 = var0_0.ConstPath.PaintingFace.Base
	local var1_26 = var0_0.ConstPath.PaintingFace.FixList
	local var2_26 = {}

	if arg0_26 and #arg0_26 > 0 then
		_.each(var1_26, function(arg0_27)
			table.insert(var2_26, string.lower(string.format(var0_26, arg0_26, arg0_27)))
		end)
	end

	return var2_26
end

function var0_0.GetPaintingShipYardIconListByPaintingName(arg0_28)
	local var0_28 = var0_0.ConstPath.PaintingShipYardIcon.Base
	local var1_28 = var0_0.ConstPath.PaintingShipYardIcon.FixList
	local var2_28 = {}

	if arg0_28 and #arg0_28 > 0 then
		_.each(var1_28, function(arg0_29)
			table.insert(var2_28, string.lower(string.format(var0_28, arg0_28, arg0_29)))
		end)
	end

	return var2_28
end

function var0_0.GetPaintingSquareIconListByPaintingName(arg0_30)
	local var0_30 = var0_0.ConstPath.PaintingSquareIcon.Base
	local var1_30 = var0_0.ConstPath.PaintingSquareIcon.FixList
	local var2_30 = {}

	if arg0_30 and #arg0_30 > 0 then
		_.each(var1_30, function(arg0_31)
			table.insert(var2_30, string.lower(string.format(var0_30, arg0_30, arg0_31)))
		end)
	end

	return var2_30
end

function var0_0.GetPaintingHeroHrzIconListByPaintingName(arg0_32)
	local var0_32 = var0_0.ConstPath.PaintingHeroHrzIcon.Base
	local var1_32 = var0_0.ConstPath.PaintingHeroHrzIcon.FixList
	local var2_32 = {}

	if arg0_32 and #arg0_32 > 0 then
		_.each(var1_32, function(arg0_33)
			table.insert(var2_32, string.lower(string.format(var0_32, arg0_32, arg0_33)))
		end)
	end

	return var2_32
end

function var0_0.GetShipSkinPaintingList(arg0_34)
	local var0_34 = pg.ship_skin_template[arg0_34].painting

	return var0_0.GetPaintingListByPaintingName(var0_34)
end

function var0_0.GetShipSkinPaintingFaceList(arg0_35)
	local var0_35 = pg.ship_skin_template[arg0_35].painting

	return var0_0.GetPaintingFaceListByPaintingName(var0_35)
end

function var0_0.GetShipSkinPaintingShipYardIconList(arg0_36)
	local var0_36 = pg.ship_skin_template[arg0_36].painting

	return var0_0.GetPaintingShipYardIconListByPaintingName(var0_36)
end

function var0_0.GetShipSkinPaintingSquareIconList(arg0_37)
	local var0_37 = pg.ship_skin_template[arg0_37].painting

	return var0_0.GetPaintingSquareIconListByPaintingName(var0_37)
end

function var0_0.GetShipSkinPaintingHeroHrzIconList(arg0_38)
	local var0_38 = pg.ship_skin_template[arg0_38].painting

	return var0_0.GetPaintingHeroHrzIconListByPaintingName(var0_38)
end

function var0_0.GetShipSkinSpineQIconList(arg0_39)
	local var0_39 = var0_0.ConstPath.SpineQIcon.Base
	local var1_39 = var0_0.ConstPath.SpineQIcon.FixList
	local var2_39 = pg.ship_skin_template[arg0_39].painting
	local var3_39 = {}

	_.each(var1_39, function(arg0_40)
		table.insert(var3_39, string.format(var0_39, var2_39, arg0_40))
	end)

	return var3_39
end

function var0_0.GetShipSkinSpineShipModelList(arg0_41)
	local var0_41 = var0_0.ConstPath.SpineModel.Base
	local var1_41 = var0_0.ConstPath.SpineModel.FixList
	local var2_41 = pg.ship_skin_template[arg0_41].painting
	local var3_41 = {}

	_.each(var1_41, function(arg0_42)
		table.insert(var3_41, string.format(var0_41, var2_41, arg0_42))
	end)

	return var3_41
end

function var0_0.GetShipSkinSpineCharList(arg0_43)
	local var0_43 = var0_0.ConstPath.SpineChar.Base
	local var1_43 = var0_0.ConstPath.SpineChar.FixList
	local var2_43 = pg.ship_skin_template[arg0_43].painting
	local var3_43 = {}

	_.each(var1_43, function(arg0_44)
		table.insert(var3_43, string.format(var0_43, var2_43, arg0_44))
	end)

	return var3_43
end

function var0_0.GetShipSkinLive2DListByPaintingName(arg0_45)
	local var0_45 = var0_0.ConstPath.Live2D.Base
	local var1_45 = var0_0.ConstPath.Live2D.FixList
	local var2_45 = {}

	if arg0_45 and #arg0_45 > 0 then
		_.each(var1_45, function(arg0_46)
			table.insert(var2_45, string.format(var0_45, arg0_45, arg0_46))
		end)
	end

	return var2_45
end

function var0_0.GetShipSkinLive2DList(arg0_47)
	local var0_47 = pg.ship_skin_template[arg0_47].painting

	return var0_0.GetShipSkinLive2DListByPaintingName(var0_47)
end

function var0_0.GetShipSkinSpinePaintingList(arg0_48)
	local var0_48 = var0_0.ConstPath.SpinePainting.Base
	local var1_48 = var0_0.ConstPath.SpinePainting.FixList
	local var2_48 = pg.ship_skin_template[arg0_48].painting
	local var3_48 = {}

	_.each(var1_48, function(arg0_49)
		table.insert(var3_48, string.format(var0_48, var2_48, arg0_49))
	end)

	return var3_48
end

function var0_0.GetShipSkinEffectList(arg0_50)
	local var0_50 = var0_0.ConstPath.UI.Base
	local var1_50 = {}
	local var2_50 = pg.ship_skin_template[arg0_50]

	if var2_50.special_effects and #var2_50.special_effects > 0 then
		local var3_50 = var2_50.special_effects[1]

		table.insert(var1_50, var0_0.CombinePath(var0_50, var3_50))
	end

	return var1_50
end

function var0_0.GetShipSkinSoundList(arg0_51)
	local var0_51 = pg.ship_skin_template[arg0_51].bgm
	local var1_51 = {}

	if var0_51 and #var0_51 > 0 then
		var1_51 = var0_0.GetSoundResList(var0_51)
	end

	return var1_51
end

function var0_0.GetShipAllRes(arg0_52)
	local var0_52 = arg0_52.configId
	local var1_52 = arg0_52:getSkinId()
	local var2_52 = {
		"spinematerials",
		"ui/lihui_qiehuan01",
		"ui/lihui_qiehuan02",
		"effect/jiehuntexiao"
	}
	local var3_52 = var0_0.GetShipRarityBgList(var0_52)
	local var4_52 = var0_0.GetShipSkinBgList(var1_52)
	local var5_52 = var0_0.GetSkillIconList(var0_52)
	local var6_52 = var0_0.GetShipSkinSoundList(var1_52)
	local var7_52 = var0_0.GetShipSkinSpineQIconList(var1_52)
	local var8_52 = var0_0.GetShipSkinSpineShipModelList(var1_52)
	local var9_52 = var0_0.GetShipSkinSpineCharList(var1_52)
	local var10_52 = var0_0.GetShipSkinSpinePaintingList(var1_52)
	local var11_52 = var0_0.GetShipSkinPaintingList(var1_52)
	local var12_52 = var0_0.GetShipSkinPaintingFaceList(var1_52)
	local var13_52 = var0_0.GetShipSkinPaintingShipYardIconList(var1_52)
	local var14_52 = var0_0.GetShipSkinPaintingSquareIconList(var1_52)
	local var15_52 = var0_0.GetShipSkinPaintingHeroHrzIconList(var1_52)
	local var16_52 = var0_0.GetShipSkinEffectList(var1_52)
	local var17_52 = var0_0.GetShipSkinLive2DList(var1_52)

	return (var0_0.MergeLuaArr(var2_52, var3_52, var4_52, var5_52, var6_52, var7_52, var8_52, var9_52, var10_52, var11_52, var12_52, var13_52, var14_52, var15_52, var16_52, var17_52))
end
