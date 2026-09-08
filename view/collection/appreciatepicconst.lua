AppreciatePicConst = {}

local var0_0 = AppreciatePicConst

var0_0.MAX_COUNT = 12
var0_0.TYPE_GALLERY = 1
var0_0.TYPE_MANGA = 2

function var0_0.filterExistGalleryPicIDList(arg0_1)
	local var0_1 = {}

	if arg0_1 and type(arg0_1) == "table" then
		for iter0_1, iter1_1 in ipairs(arg0_1) do
			local var1_1 = GalleryConst.GetGalleryPicPathByID(iter1_1)

			if var1_1 and checkABExist(var1_1) then
				table.insert(var0_1, iter1_1)
			end
		end
	end

	return var0_1
end

function var0_0.filterExistMangaPicIDList(arg0_2)
	local var0_2 = {}

	if arg0_2 and type(arg0_2) == "table" then
		for iter0_2, iter1_2 in ipairs(arg0_2) do
			local var1_2 = MangaConst.GetMangaPicPathByID(iter1_2)

			if var1_2 and checkABExist(var1_2) then
				table.insert(var0_2, iter1_2)
			end
		end
	end

	return var0_2
end

function var0_0.getDefaultGalleryPicIDList()
	local var0_3 = {
		1001,
		1002,
		1003,
		1004,
		1005,
		1006,
		1007,
		1008,
		1009,
		1010,
		1011,
		1012
	}
	local var1_3 = {}

	for iter0_3, iter1_3 in ipairs(var0_3) do
		if pg.gallery_config[iter1_3] then
			table.insert(var1_3, iter1_3)
		end
	end

	return var1_3
end

function var0_0.getOldLoadingPicIDList()
	local var0_4 = {}

	for iter0_4, iter1_4 in ipairs(pg.gallery_config.all) do
		if iter1_4 > 1000 then
			table.insert(var0_4, iter1_4)
		end
	end

	return var0_4
end

function var0_0.createPicInfo(arg0_5, arg1_5)
	local var0_5 = {
		type = arg0_5,
		id = arg1_5
	}

	if arg0_5 == var0_0.TYPE_GALLERY then
		var0_5.path = GalleryConst.GetGalleryPicPathByID(arg1_5)
	elseif arg0_5 == var0_0.TYPE_MANGA then
		var0_5.path = MangaConst.GetMangaPicPathByID(arg1_5)
	end

	return var0_5
end

function var0_0.getRandomLoadingPic()
	if not getProxy(LoadingPicProxy) then
		return nil
	end

	local var0_6 = getProxy(LoadingPicProxy):getGalleryPicIDList()
	local var1_6 = getProxy(LoadingPicProxy):getMangaPicIDList()
	local var2_6 = AppreciatePicConst.filterExistGalleryPicIDList(var0_6)
	local var3_6 = AppreciatePicConst.filterExistMangaPicIDList(var1_6)
	local var4_6 = getProxy(LoadingPicProxy):getDiyModeOpenFlag()
	local var5_6 = #var2_6 + #var3_6

	if not var4_6 or var5_6 == 0 then
		var2_6 = var0_0.getDefaultGalleryPicIDList()
		var3_6 = {}
	end

	local var6_6 = #var2_6 + #var3_6

	assert(var6_6 > 0, "loading pic count should be greater than 0")

	local var7_6
	local var8_6 = math.random(1, var6_6)

	if var8_6 <= #var2_6 then
		local var9_6 = var2_6[var8_6]

		var7_6 = var0_0.createPicInfo(var0_0.TYPE_GALLERY, var9_6)
	else
		local var10_6 = var3_6[var8_6 - #var2_6]

		var7_6 = var0_0.createPicInfo(var0_0.TYPE_MANGA, var10_6)
	end

	return var7_6
end

function var0_0.checkDownloadMissingPic(arg0_7)
	local var0_7 = AppreciatePicConst.getDefaultGalleryPicIDList()
	local var1_7 = {}
	local var2_7 = {}

	if getProxy(LoadingPicProxy) then
		var1_7 = getProxy(LoadingPicProxy):getGalleryPicIDList()
		var2_7 = getProxy(LoadingPicProxy):getMangaPicIDList()
	end

	local var3_7 = {}

	for iter0_7, iter1_7 in ipairs(var0_7) do
		local var4_7 = GalleryConst.GetGalleryPicPathByID(iter1_7)

		if var4_7 then
			table.insert(var3_7, var4_7)
			table.insert(var3_7, var4_7 .. "_hx")
		end
	end

	for iter2_7, iter3_7 in ipairs(var1_7) do
		local var5_7 = GalleryConst.GetGalleryPicPathByID(iter3_7)

		if var5_7 then
			table.insert(var3_7, var5_7)
			table.insert(var3_7, var5_7 .. "_hx")
		end
	end

	for iter4_7, iter5_7 in ipairs(var2_7) do
		local var6_7 = MangaConst.GetMangaPicPathByID(iter5_7)

		if var6_7 then
			table.insert(var3_7, var6_7)
			table.insert(var3_7, var6_7 .. "_hx")
		end
	end

	if var3_7 and #var3_7 > 0 then
		local var7_7 = {}

		var7_7.isShowBox = false
		var7_7.fileList = var3_7
		var7_7.finishFunc = arg0_7

		function var7_7.onNo()
			return
		end

		function var7_7.onClose()
			return
		end

		DownloadConst.Download(var7_7)
	elseif arg0_7 then
		arg0_7()
	end
end

function var0_0.isUsedPicInfo(arg0_10)
	local var0_10 = false

	if arg0_10.type == var0_0.TYPE_GALLERY then
		var0_10 = table.contains(getProxy(LoadingPicProxy):getGalleryPicIDList(true), arg0_10.id)
	elseif arg0_10.type == var0_0.TYPE_MANGA then
		var0_10 = table.contains(getProxy(LoadingPicProxy):getMangaPicIDList(true), arg0_10.id)
	end

	return var0_10
end

function var0_0.isNewPicInfo(arg0_11)
	local var0_11 = var0_0.getGalleryConfigNewIDList()
	local var1_11 = var0_0.getMangaConfigNewIDList()

	if arg0_11.type == var0_0.TYPE_GALLERY then
		if not table.contains(var0_11, arg0_11.id) then
			return false
		end
	elseif arg0_11.type == var0_0.TYPE_MANGA and not table.contains(var1_11, arg0_11.id) then
		return false
	end

	local var2_11 = getProxy(LoadingPicProxy):getGalleryNewPicOpenList(true)
	local var3_11 = getProxy(LoadingPicProxy):getMangaNewPicOpenList(true)

	if arg0_11.type == var0_0.TYPE_GALLERY then
		if table.contains(var2_11, arg0_11.id) then
			return false
		end
	elseif arg0_11.type == var0_0.TYPE_MANGA and table.contains(var3_11, arg0_11.id) then
		return false
	end

	return true
end

function var0_0.isPicInfoLiked(arg0_12)
	local var0_12 = false

	if arg0_12.type == var0_0.TYPE_GALLERY then
		var0_12 = GalleryConst.isGalleryLikeByID(arg0_12.id)
	elseif arg0_12.type == var0_0.TYPE_MANGA then
		var0_12 = MangaConst.isMangaLikeByID(arg0_12.id)
	end

	return var0_12
end

function var0_0.getGalleryConfigNewIDList()
	local var0_13 = pg.gameset.new_gallery_id_list.description

	if var0_13 == nil or type(var0_13) ~= "table" then
		var0_13 = {}
	end

	return var0_13
end

function var0_0.getMangaConfigNewIDList()
	local var0_14 = pg.gameset.new_manga_id_list.description

	if var0_14 == nil or type(var0_14) ~= "table" then
		var0_14 = {}
	end

	return var0_14
end

return var0_0
