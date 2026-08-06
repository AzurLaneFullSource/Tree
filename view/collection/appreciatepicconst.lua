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

function var0_0.createPicInfo(arg0_4, arg1_4)
	local var0_4 = {
		type = arg0_4,
		id = arg1_4
	}

	if arg0_4 == var0_0.TYPE_GALLERY then
		var0_4.path = GalleryConst.GetGalleryPicPathByID(arg1_4)
	elseif arg0_4 == var0_0.TYPE_MANGA then
		var0_4.path = MangaConst.GetMangaPicPathByID(arg1_4)
	end

	return var0_4
end

function var0_0.getRandomLoadingPic()
	if not getProxy(LoadingPicProxy) then
		return nil
	end

	local var0_5 = getProxy(LoadingPicProxy):getGalleryPicIDList()
	local var1_5 = getProxy(LoadingPicProxy):getMangaPicIDList()
	local var2_5 = AppreciatePicConst.filterExistGalleryPicIDList(var0_5)
	local var3_5 = AppreciatePicConst.filterExistMangaPicIDList(var1_5)
	local var4_5 = getProxy(LoadingPicProxy):getDiyModeOpenFlag()
	local var5_5 = #var2_5 + #var3_5

	if not var4_5 or var5_5 == 0 then
		var2_5 = var0_0.getDefaultGalleryPicIDList()
		var3_5 = {}
	end

	local var6_5 = #var2_5 + #var3_5

	assert(var6_5 > 0, "loading pic count should be greater than 0")

	local var7_5
	local var8_5 = math.random(1, var6_5)

	if var8_5 <= #var2_5 then
		local var9_5 = var2_5[var8_5]

		var7_5 = var0_0.createPicInfo(var0_0.TYPE_GALLERY, var9_5)
	else
		local var10_5 = var3_5[var8_5 - #var2_5]

		var7_5 = var0_0.createPicInfo(var0_0.TYPE_MANGA, var10_5)
	end

	return var7_5
end

function var0_0.checkDownloadMissingPic(arg0_6)
	local var0_6 = AppreciatePicConst.getDefaultGalleryPicIDList()
	local var1_6 = {}
	local var2_6 = {}

	if getProxy(LoadingPicProxy) then
		var1_6 = getProxy(LoadingPicProxy):getGalleryPicIDList()
		var2_6 = getProxy(LoadingPicProxy):getMangaPicIDList()
	end

	local var3_6 = {}

	for iter0_6, iter1_6 in ipairs(var0_6) do
		local var4_6 = GalleryConst.GetGalleryPicPathByID(iter1_6)

		if var4_6 then
			table.insert(var3_6, var4_6)
			table.insert(var3_6, var4_6 .. "_hx")
		end
	end

	for iter2_6, iter3_6 in ipairs(var1_6) do
		local var5_6 = GalleryConst.GetGalleryPicPathByID(iter3_6)

		if var5_6 then
			table.insert(var3_6, var5_6)
			table.insert(var3_6, var5_6 .. "_hx")
		end
	end

	for iter4_6, iter5_6 in ipairs(var2_6) do
		local var6_6 = MangaConst.GetMangaPicPathByID(iter5_6)

		if var6_6 then
			table.insert(var3_6, var6_6)
			table.insert(var3_6, var6_6 .. "_hx")
		end
	end

	if var3_6 and #var3_6 > 0 then
		local var7_6 = {}

		var7_6.isShowBox = false
		var7_6.fileList = var3_6
		var7_6.finishFunc = arg0_6

		function var7_6.onNo()
			return
		end

		function var7_6.onClose()
			return
		end

		DownloadConst.Download(var7_6)
	elseif arg0_6 then
		arg0_6()
	end
end

function var0_0.isUsedPicInfo(arg0_9)
	local var0_9 = false

	if arg0_9.type == var0_0.TYPE_GALLERY then
		var0_9 = table.contains(getProxy(LoadingPicProxy):getGalleryPicIDList(true), arg0_9.id)
	elseif arg0_9.type == var0_0.TYPE_MANGA then
		var0_9 = table.contains(getProxy(LoadingPicProxy):getMangaPicIDList(true), arg0_9.id)
	end

	return var0_9
end

function var0_0.isNewPicInfo(arg0_10)
	local var0_10 = var0_0.getGalleryConfigNewIDList()
	local var1_10 = var0_0.getMangaConfigNewIDList()

	if arg0_10.type == var0_0.TYPE_GALLERY then
		if not table.contains(var0_10, arg0_10.id) then
			return false
		end
	elseif arg0_10.type == var0_0.TYPE_MANGA and not table.contains(var1_10, arg0_10.id) then
		return false
	end

	local var2_10 = getProxy(LoadingPicProxy):getGalleryNewPicOpenList(true)
	local var3_10 = getProxy(LoadingPicProxy):getMangaNewPicOpenList(true)

	if arg0_10.type == var0_0.TYPE_GALLERY then
		if table.contains(var2_10, arg0_10.id) then
			return false
		end
	elseif arg0_10.type == var0_0.TYPE_MANGA and table.contains(var3_10, arg0_10.id) then
		return false
	end

	return true
end

function var0_0.isPicInfoLiked(arg0_11)
	local var0_11 = false

	if arg0_11.type == var0_0.TYPE_GALLERY then
		var0_11 = GalleryConst.isGalleryLikeByID(arg0_11.id)
	elseif arg0_11.type == var0_0.TYPE_MANGA then
		var0_11 = MangaConst.isMangaLikeByID(arg0_11.id)
	end

	return var0_11
end

function var0_0.getGalleryConfigNewIDList()
	local var0_12 = pg.gameset.new_gallery_id_list.description

	if var0_12 == nil or type(var0_12) ~= "table" then
		var0_12 = {}
	end

	return var0_12
end

function var0_0.getMangaConfigNewIDList()
	local var0_13 = pg.gameset.new_manga_id_list.description

	if var0_13 == nil or type(var0_13) ~= "table" then
		var0_13 = {}
	end

	return var0_13
end

return var0_0
