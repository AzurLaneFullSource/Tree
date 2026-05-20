local var0_0 = class("LoadingPicProxy", import(".NetProxy"))
local var1_0 = false
local var2_0 = "LoadingPicProxy"

local function var3_0(...)
	if var1_0 then
		print(var2_0, ...)
	end
end

function var0_0.register(arg0_2)
	arg0_2:initData()
	arg0_2:addListener()
end

function var0_0.initData(arg0_3)
	arg0_3.diyModeOpenFlag = false
	arg0_3.galleryPicIDList = {}
	arg0_3.mangaPicIDList = {}
	arg0_3.galleryNewPicOpenList = {}
	arg0_3.mangaNewPicOpenList = {}

	arg0_3:initNewPicOpenList()
end

function var0_0.addListener(arg0_4)
	arg0_4:on(11003, function(arg0_5)
		arg0_4:updateDiyModeOpenFlag(arg0_5.loading_pic_open_flag)
		arg0_4:updateGalleryPicIDList(arg0_5.loading_pic_id_list_1)
		arg0_4:updateMangaPicIDList(arg0_5.loading_pic_id_list_2)
		arg0_4:checkExistCount()
	end)
end

function var0_0.updateDiyModeOpenFlag(arg0_6, arg1_6)
	if type(arg1_6) == "number" then
		if arg1_6 == 1 then
			arg1_6 = true
		elseif arg1_6 == 0 then
			arg1_6 = false
		end
	end

	arg0_6.diyModeOpenFlag = tobool(arg1_6)

	var3_0("updateDiyModeOpenFlag", arg1_6, tostring(arg0_6.diyModeOpenFlag))
end

function var0_0.getDiyModeOpenFlag(arg0_7)
	var3_0("getDiyModeOpenFlag", tostring(arg0_7.diyModeOpenFlag))

	return arg0_7.diyModeOpenFlag
end

function var0_0.updateGalleryPicIDList(arg0_8, arg1_8)
	arg0_8.galleryPicIDList = {}

	for iter0_8, iter1_8 in ipairs(arg1_8) do
		iter1_8 = tonumber(iter1_8)

		table.insert(arg0_8.galleryPicIDList, iter1_8)
	end

	var3_0("updateGalleryPicIDList", table.concat(arg0_8.galleryPicIDList, ","))
end

function var0_0.getGalleryPicIDList(arg0_9, arg1_9)
	var3_0("getGalleryPicIDList", table.concat(arg0_9.galleryPicIDList, ","))

	return arg1_9 and arg0_9.galleryPicIDList or Clone(arg0_9.galleryPicIDList)
end

function var0_0.updateMangaPicIDList(arg0_10, arg1_10)
	arg0_10.mangaPicIDList = {}

	for iter0_10, iter1_10 in ipairs(arg1_10) do
		iter1_10 = tonumber(iter1_10)

		table.insert(arg0_10.mangaPicIDList, iter1_10)
	end

	var3_0("updateMangaPicIDList", table.concat(arg0_10.mangaPicIDList, ","))
end

function var0_0.getMangaPicIDList(arg0_11, arg1_11)
	var3_0("getMangaPicIDList", table.concat(arg0_11.mangaPicIDList, ","))

	return arg1_11 and arg0_11.mangaPicIDList or Clone(arg0_11.mangaPicIDList)
end

function var0_0.checkExistCount(arg0_12)
	local var0_12 = AppreciatePicConst.filterExistGalleryPicIDList(arg0_12:getGalleryPicIDList(true))
	local var1_12 = AppreciatePicConst.filterExistMangaPicIDList(arg0_12:getMangaPicIDList(true))

	if #var0_12 + #var1_12 == 0 then
		local var2_12 = AppreciatePicConst.getDefaultGalleryPicIDList()
		local var3_12 = {
			galleryPicIDList = var2_12
		}

		arg0_12:sendNotification(GAME.UPDATE_LOADING_PIC_DONE, var3_12)
	end
end

function var0_0.initNewPicOpenList(arg0_13)
	local var0_13 = PlayerPrefs.GetString("galleryNew_pic_open_list", "")
	local var1_13 = PlayerPrefs.GetString("mangaNew_pic_open_list", "")

	arg0_13.galleryNewPicOpenList = {}
	arg0_13.mangaNewPicOpenList = {}

	for iter0_13, iter1_13 in ipairs(var0_13:split(",")) do
		iter1_13 = tonumber(iter1_13)

		if not table.contains(arg0_13.galleryNewPicOpenList, iter1_13) then
			table.insert(arg0_13.galleryNewPicOpenList, iter1_13)
		end
	end

	for iter2_13, iter3_13 in ipairs(var1_13:split(",")) do
		iter3_13 = tonumber(iter3_13)

		if not table.contains(arg0_13.mangaNewPicOpenList, iter3_13) then
			table.insert(arg0_13.mangaNewPicOpenList, iter3_13)
		end
	end
end

function var0_0.addGalleryNewPicOpenList(arg0_14, arg1_14)
	local var0_14 = AppreciatePicConst.getGalleryConfigNewIDList()

	if not table.contains(var0_14, arg1_14) then
		return
	end

	if not table.contains(arg0_14.galleryNewPicOpenList, arg1_14) then
		table.insert(arg0_14.galleryNewPicOpenList, arg1_14)
	end

	arg0_14:saveNewPicOpenList()
end

function var0_0.addMangaNewPicOpenList(arg0_15, arg1_15)
	local var0_15 = AppreciatePicConst.getMangaConfigNewIDList()

	if not table.contains(var0_15, arg1_15) then
		return
	end

	if not table.contains(arg0_15.mangaNewPicOpenList, arg1_15) then
		table.insert(arg0_15.mangaNewPicOpenList, arg1_15)
	end

	arg0_15:saveNewPicOpenList()
end

function var0_0.saveNewPicOpenList(arg0_16)
	PlayerPrefs.SetString("galleryNew_pic_open_list", table.concat(arg0_16.galleryNewPicOpenList, ","))
	PlayerPrefs.SetString("mangaNew_pic_open_list", table.concat(arg0_16.mangaNewPicOpenList, ","))
	PlayerPrefs.Save()
end

function var0_0.getGalleryNewPicOpenList(arg0_17, arg1_17)
	return arg1_17 and arg0_17.galleryNewPicOpenList or Clone(arg0_17.galleryNewPicOpenList)
end

function var0_0.getMangaNewPicOpenList(arg0_18, arg1_18)
	return arg1_18 and arg0_18.mangaNewPicOpenList or Clone(arg0_18.mangaNewPicOpenList)
end

return var0_0
