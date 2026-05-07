ResPathSupport = {}

local var0_0 = ResPathSupport

var0_0.ConstPath = {}
var0_0.ConstPath.BG = {}
var0_0.ConstPath.BG.CommonBG = "commonbg"
var0_0.ConstPath.BG.ShipRarityBG = "bg/star_level_bg_%s%s"
var0_0.ConstPath.BG.ShipRarityUI = "ui/star_level_bg_%s%s"
var0_0.ConstPath.BG.ShipBGFixList = {
	"",
	"_0",
	"_1"
}
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
var0_0.ConstPath.UI = {}
var0_0.ConstPath.UI.Base = "ui"
var0_0.ConstPath.UI.LivingAreaCover = "livingareacover"
var0_0.ConstPath.UI.ActivityBanner = "activitybanner"
var0_0.ConstPath.UI.LinkButton = "linkbutton"
var0_0.ConstPath.UI.ShipSkillIcon = "skillicon"

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

function var0_0.CombinePath(...)
	local var0_2 = {
		...
	}

	return table.concat(var0_2, "/")
end

function var0_0.GetSoundResList(arg0_3)
	local var0_3 = {
		var0_0.ConstPath.Sound.Default,
		var0_0.ConstPath.Sound.BGM
	}
	local var1_3 = {}

	if arg0_3 and #arg0_3 > 0 then
		_.each(var0_3, function(arg0_4)
			table.insert(var1_3, string.format(arg0_4, arg0_3))
		end)
	end

	return var1_3
end

function var0_0.GetShipRarityBgList(arg0_5)
	local var0_5 = pg.ship_data_statistics[arg0_5].rarity
	local var1_5 = {
		var0_5,
		var0_5 + 1
	}
	local var2_5 = var0_0.ConstPath.BG.ShipBGFixList
	local var3_5 = {
		var0_0.ConstPath.BG.ShipRarityBG,
		var0_0.ConstPath.BG.ShipRarityUI
	}
	local var4_5 = {}

	_.each(var3_5, function(arg0_6)
		_.each(var1_5, function(arg0_7)
			_.each(var2_5, function(arg0_8)
				table.insert(var4_5, string.lower(string.format(arg0_6, arg0_7, arg0_8)))
			end)
		end)
	end)

	return var4_5
end

function var0_0.GetShipSkinBgList(arg0_9)
	local var0_9 = pg.ship_skin_template[arg0_9]
	local var1_9 = {
		var0_9.bg_sp,
		var0_9.bg,
		var0_9.rarity_bg
	}
	local var2_9 = {
		var0_0.ConstPath.BG.ShipRarityBG,
		var0_0.ConstPath.BG.ShipRarityUI
	}
	local var3_9 = {}

	_.each(var2_9, function(arg0_10)
		_.each(var1_9, function(arg0_11)
			if arg0_11 and #arg0_11 > 0 then
				table.insert(var3_9, string.lower(string.format(arg0_10, arg0_11, "")))
			end
		end)
	end)

	return var3_9
end

function var0_0.GetSkillIconList(arg0_12)
	local var0_12 = var0_0.ConstPath.UI.ShipSkillIcon
	local var1_12 = pg.ship_data_template[arg0_12].buff_list_display
	local var2_12 = {}

	_.each(var1_12, function(arg0_13)
		local var0_13 = getSkillConfig(arg0_13)
		local var1_13 = tostring(var0_13.icon)

		if var1_13 and #var1_13 > 0 then
			local var2_13 = var0_0.CombinePath(var0_12, var1_13)
			local var3_13 = string.lower(var2_13)

			table.insert(var2_12, var3_13)
		end
	end)

	return var2_12
end

function var0_0.GetSpineCharListByPrefabName(arg0_14)
	local var0_14 = var0_0.ConstPath.SpineChar.Base
	local var1_14 = var0_0.ConstPath.SpineChar.FixList
	local var2_14 = {}

	if arg0_14 and #arg0_14 > 0 then
		_.each(var1_14, function(arg0_15)
			table.insert(var2_14, string.lower(string.format(var0_14, arg0_14, arg0_15)))
		end)
	end

	return var2_14
end

function var0_0.GetSpineQIconListByPrefabName(arg0_16)
	local var0_16 = var0_0.ConstPath.SpineQIcon.Base
	local var1_16 = var0_0.ConstPath.SpineQIcon.FixList
	local var2_16 = {}

	if arg0_16 and #arg0_16 > 0 then
		_.each(var1_16, function(arg0_17)
			table.insert(var2_16, string.lower(string.format(var0_16, arg0_16, arg0_17)))
		end)
	end

	return var2_16
end

function var0_0.GetSpineModelsByPrefabName(arg0_18)
	local var0_18 = var0_0.ConstPath.SpineModel.Base
	local var1_18 = var0_0.ConstPath.SpineModel.FixList
	local var2_18 = {}

	if arg0_18 and #arg0_18 > 0 then
		_.each(var1_18, function(arg0_19)
			table.insert(var2_18, string.lower(string.format(var0_18, arg0_18, arg0_19)))
		end)
	end

	return var2_18
end

function var0_0.GetPaintingListByPaintingName(arg0_20)
	local var0_20 = var0_0.ConstPath.Painting.Base
	local var1_20 = var0_0.ConstPath.Painting.FixList
	local var2_20 = {}

	if arg0_20 and #arg0_20 > 0 then
		_.each(var1_20, function(arg0_21)
			table.insert(var2_20, string.lower(string.format(var0_20, arg0_20, arg0_21)))
		end)
	end

	return var2_20
end

function var0_0.GetPaintingFaceListByPaintingName(arg0_22)
	local var0_22 = var0_0.ConstPath.PaintingFace.Base
	local var1_22 = var0_0.ConstPath.PaintingFace.FixList
	local var2_22 = {}

	if arg0_22 and #arg0_22 > 0 then
		_.each(var1_22, function(arg0_23)
			table.insert(var2_22, string.lower(string.format(var0_22, arg0_22, arg0_23)))
		end)
	end

	return var2_22
end

function var0_0.GetPaintingShipYardIconListByPaintingName(arg0_24)
	local var0_24 = var0_0.ConstPath.PaintingShipYardIcon.Base
	local var1_24 = var0_0.ConstPath.PaintingShipYardIcon.FixList
	local var2_24 = {}

	if arg0_24 and #arg0_24 > 0 then
		_.each(var1_24, function(arg0_25)
			table.insert(var2_24, string.lower(string.format(var0_24, arg0_24, arg0_25)))
		end)
	end

	return var2_24
end

function var0_0.GetPaintingSquareIconListByPaintingName(arg0_26)
	local var0_26 = var0_0.ConstPath.PaintingSquareIcon.Base
	local var1_26 = var0_0.ConstPath.PaintingSquareIcon.FixList
	local var2_26 = {}

	if arg0_26 and #arg0_26 > 0 then
		_.each(var1_26, function(arg0_27)
			table.insert(var2_26, string.lower(string.format(var0_26, arg0_26, arg0_27)))
		end)
	end

	return var2_26
end

function var0_0.GetPaintingHeroHrzIconListByPaintingName(arg0_28)
	local var0_28 = var0_0.ConstPath.PaintingHeroHrzIcon.Base
	local var1_28 = var0_0.ConstPath.PaintingHeroHrzIcon.FixList
	local var2_28 = {}

	if arg0_28 and #arg0_28 > 0 then
		_.each(var1_28, function(arg0_29)
			table.insert(var2_28, string.lower(string.format(var0_28, arg0_28, arg0_29)))
		end)
	end

	return var2_28
end

function var0_0.GetShipSkinPaintingList(arg0_30)
	local var0_30 = pg.ship_skin_template[arg0_30].painting

	return var0_0.GetPaintingListByPaintingName(var0_30)
end

function var0_0.GetShipSkinPaintingFaceList(arg0_31)
	local var0_31 = pg.ship_skin_template[arg0_31].painting

	return var0_0.GetPaintingFaceListByPaintingName(var0_31)
end

function var0_0.GetShipSkinPaintingShipYardIconList(arg0_32)
	local var0_32 = pg.ship_skin_template[arg0_32].painting

	return var0_0.GetPaintingShipYardIconListByPaintingName(var0_32)
end

function var0_0.GetShipSkinPaintingSquareIconList(arg0_33)
	local var0_33 = pg.ship_skin_template[arg0_33].painting

	return var0_0.GetPaintingSquareIconListByPaintingName(var0_33)
end

function var0_0.GetShipSkinPaintingHeroHrzIconList(arg0_34)
	local var0_34 = pg.ship_skin_template[arg0_34].painting

	return var0_0.GetPaintingHeroHrzIconListByPaintingName(var0_34)
end

function var0_0.GetShipSkinSpineQIconList(arg0_35)
	local var0_35 = var0_0.ConstPath.SpineQIcon.Base
	local var1_35 = var0_0.ConstPath.SpineQIcon.FixList
	local var2_35 = pg.ship_skin_template[arg0_35].painting
	local var3_35 = {}

	_.each(var1_35, function(arg0_36)
		table.insert(var3_35, string.format(var0_35, var2_35, arg0_36))
	end)

	return var3_35
end

function var0_0.GetShipSkinSpineShipModelList(arg0_37)
	local var0_37 = var0_0.ConstPath.SpineModel.Base
	local var1_37 = var0_0.ConstPath.SpineModel.FixList
	local var2_37 = pg.ship_skin_template[arg0_37].painting
	local var3_37 = {}

	_.each(var1_37, function(arg0_38)
		table.insert(var3_37, string.format(var0_37, var2_37, arg0_38))
	end)

	return var3_37
end

function var0_0.GetShipSkinSpineCharList(arg0_39)
	local var0_39 = var0_0.ConstPath.SpineChar.Base
	local var1_39 = var0_0.ConstPath.SpineChar.FixList
	local var2_39 = pg.ship_skin_template[arg0_39].painting
	local var3_39 = {}

	_.each(var1_39, function(arg0_40)
		table.insert(var3_39, string.format(var0_39, var2_39, arg0_40))
	end)

	return var3_39
end

function var0_0.GetShipSkinLive2DList(arg0_41)
	local var0_41 = var0_0.ConstPath.Live2D.Base
	local var1_41 = var0_0.ConstPath.Live2D.FixList
	local var2_41 = pg.ship_skin_template[arg0_41].painting
	local var3_41 = {}

	_.each(var1_41, function(arg0_42)
		table.insert(var3_41, string.format(var0_41, var2_41, arg0_42))
	end)

	return var3_41
end

function var0_0.GetShipSkinSpinePaintingList(arg0_43)
	local var0_43 = var0_0.ConstPath.SpinePainting.Base
	local var1_43 = var0_0.ConstPath.SpinePainting.FixList
	local var2_43 = pg.ship_skin_template[arg0_43].painting
	local var3_43 = {}

	_.each(var1_43, function(arg0_44)
		table.insert(var3_43, string.format(var0_43, var2_43, arg0_44))
	end)

	return var3_43
end

function var0_0.GetShipSkinEffectList(arg0_45)
	local var0_45 = var0_0.ConstPath.UI.Base
	local var1_45 = {}
	local var2_45 = pg.ship_skin_template[arg0_45]

	if var2_45.special_effects and #var2_45.special_effects > 0 then
		local var3_45 = var2_45.special_effects[1]

		table.insert(var1_45, var0_0.CombinePath(var0_45, var3_45))
	end

	return var1_45
end

function var0_0.GetShipSkinSoundList(arg0_46)
	local var0_46 = pg.ship_skin_template[arg0_46].bgm
	local var1_46 = {}

	if var0_46 and #var0_46 > 0 then
		var1_46 = var0_0.GetSoundResList(var0_46)
	end

	return var1_46
end

function var0_0.GetShipAllRes(arg0_47)
	local var0_47 = arg0_47.configId
	local var1_47 = arg0_47:getSkinId()
	local var2_47 = {
		"spinematerials",
		"ui/lihui_qiehuan01",
		"ui/lihui_qiehuan02",
		"effect/jiehuntexiao"
	}
	local var3_47 = var0_0.GetShipRarityBgList(var0_47)
	local var4_47 = var0_0.GetShipSkinBgList(var1_47)
	local var5_47 = var0_0.GetSkillIconList(var0_47)
	local var6_47 = var0_0.GetShipSkinSoundList(var1_47)
	local var7_47 = var0_0.GetShipSkinSpineQIconList(var1_47)
	local var8_47 = var0_0.GetShipSkinSpineShipModelList(var1_47)
	local var9_47 = var0_0.GetShipSkinSpineCharList(var1_47)
	local var10_47 = var0_0.GetShipSkinSpinePaintingList(var1_47)
	local var11_47 = var0_0.GetShipSkinPaintingList(var1_47)
	local var12_47 = var0_0.GetShipSkinPaintingFaceList(var1_47)
	local var13_47 = var0_0.GetShipSkinPaintingShipYardIconList(var1_47)
	local var14_47 = var0_0.GetShipSkinPaintingSquareIconList(var1_47)
	local var15_47 = var0_0.GetShipSkinPaintingHeroHrzIconList(var1_47)
	local var16_47 = var0_0.GetShipSkinEffectList(var1_47)

	return (var0_0.MergeLuaArr(var2_47, var3_47, var4_47, var5_47, var6_47, var7_47, var8_47, var9_47, var10_47, var11_47, var12_47, var13_47, var14_47, var15_47, var16_47))
end
