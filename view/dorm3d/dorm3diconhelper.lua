local var0_0 = class("Dorm3dIconHelper")

var0_0.CAMERA_VOLUME = 1
var0_0.CAMERA_FRAME = 2
var0_0.DORM_STORY = 3

function var0_0.UpdateDorm3dIcon(arg0_1, arg1_1)
	local var0_1 = var0_0.Data2Config(arg1_1)

	GetImageSpriteFromAtlasAsync("weaponframes", var0_1.frame, arg0_1)

	local var1_1 = arg0_1:Find("icon")

	GetImageSpriteFromAtlasAsync(var0_1.icon, "", var1_1)
	setText(arg0_1:Find("count/Text"), "x" .. var0_1.count)
	setText(arg0_1:Find("name/Text"), var0_1.name)
end

function var0_0.Data2Config(arg0_2)
	local var0_2 = switch(arg0_2[1], {
		[var0_0.CAMERA_VOLUME] = function()
			local var0_3 = pg.dorm3d_camera_volume_template[arg0_2[2]]

			return {
				name = var0_3.name,
				icon = var0_3.icon,
				rarity = var0_3.rarity,
				desc = var0_3.desc
			}
		end,
		[var0_0.CAMERA_FRAME] = function()
			local var0_4 = pg.dorm3d_camera_photo_frame[arg0_2[2]]

			return {
				name = var0_4.name,
				icon = var0_4.icon,
				rarity = var0_4.rarity,
				desc = var0_4.desc
			}
		end,
		[var0_0.DORM_STORY] = function()
			local var0_5 = pg.dorm3d_recall[arg0_2[2]]

			return {
				name = var0_5.name,
				icon = "dorm3dicon/" .. var0_5.image .. "_icon",
				rarity = var0_5.rarity,
				desc = var0_5.desc
			}
		end
	})

	var0_2.frame = "dorm3d_" .. (var0_2.rarity and ItemRarity.Rarity2Print(var0_2.rarity) or "2")
	var0_2.count = arg0_2[3]

	return var0_2
end

function var0_0.SplitStory(arg0_6)
	local var0_6 = {}
	local var1_6

	for iter0_6, iter1_6 in pairs(arg0_6) do
		if iter1_6[1] ~= var0_0.DORM_STORY then
			table.insert(var0_6, iter1_6)
		else
			var1_6 = iter1_6
		end
	end

	return var0_6, var1_6
end

return var0_0
