local var0 = class("AppreciateProxy", import(".NetProxy"))

function var0.register(arg0)
	arg0:initData()
	arg0:checkPicFileState()
	arg0:checkMusicFileState()
end

function var0.initData(arg0)
	arg0.picManager = BundleWizard.Inst:GetGroupMgr("GALLERY_PIC")
	arg0.musicManager = BundleWizard.Inst:GetGroupMgr("GALLERY_BGM")
	arg0.reForVer = PathMgr.MD5Result
	arg0.galleryPicUnLockIDLIst = {}
	arg0.galleryPicExistStateTable = {}
	arg0.galleryPicLikeIDList = {}
	arg0.musicUnLockIDLIst = {}
	arg0.musicExistStateTable = {}
	arg0.musicLikeIDList = {}
	arg0.mangaReadIDList = {}
	arg0.mangaLikeIDList = {}
	arg0.galleryRunData = {
		middleIndex = 1,
		dateValue = GalleryConst.Data_All_Value,
		sortValue = GalleryConst.Sort_Order_Up,
		likeValue = GalleryConst.Filte_Normal_Value,
		bgFilteValue = GalleryConst.Loading_BG_NO_Filte
	}
	arg0.musicRunData = {
		middleIndex = 1,
		sortValue = MusicCollectionConst.Sort_Order_Up,
		likeValue = MusicCollectionConst.Filte_Normal_Value
	}
end

function var0.checkPicFileState(arg0)
	local var0
	local var1

	for iter0, iter1 in ipairs(pg.gallery_config.all) do
		local var2 = pg.gallery_config[iter1].illustration
		local var3 = GalleryConst.PIC_PATH_PREFIX .. var2
		local var4 = checkABExist(var3)

		arg0.galleryPicExistStateTable[iter1] = var4
	end
end

function var0.checkMusicFileState(arg0)
	local var0
	local var1

	for iter0, iter1 in ipairs(pg.music_collect_config.all) do
		local var2 = pg.music_collect_config[iter1].music
		local var3 = MusicCollectionConst.MUSIC_SONG_PATH_PREFIX .. var2 .. ".b"
		local var4 = checkABExist(var3)

		arg0.musicExistStateTable[iter1] = var4
	end
end

function var0.updatePicFileExistStateTable(arg0, arg1, arg2)
	arg0.galleryPicExistStateTable[arg1] = arg2
end

function var0.updateMusicFileExistStateTable(arg0, arg1, arg2)
	arg0.musicExistStateTable[arg1] = arg2
end

function var0.getPicExistStateByID(arg0, arg1)
	if not arg1 then
		assert("不能为空的picID:" .. tostring(arg1))
	end

	return arg0.galleryPicExistStateTable[arg1]
end

function var0.getMusicExistStateByID(arg0, arg1)
	if not arg1 then
		assert("不能为空的musicID:" .. tostring(arg1))
	end

	return arg0.musicExistStateTable[arg1]
end

function var0.getSinglePicConfigByID(arg0, arg1)
	local var0 = pg.gallery_config[arg1]

	if var0 then
		return var0
	else
		assert(false, "不存在的插画ID:" .. tostring(arg1))
	end
end

function var0.getSingleMusicConfigByID(arg0, arg1)
	local var0 = pg.music_collect_config[arg1]

	if var0 then
		return var0
	else
		assert(false, "不存在的音乐ID:" .. tostring(arg1))
	end
end

function var0.updateGalleryRunData(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0.galleryRunData.dateValue = arg1 and arg1 or arg0.galleryRunData.dateValue
	arg0.galleryRunData.sortValue = arg2 and arg2 or arg0.galleryRunData.sortValue
	arg0.galleryRunData.middleIndex = arg3 and arg3 or arg0.galleryRunData.middleIndex
	arg0.galleryRunData.likeValue = arg4 and arg4 or arg0.galleryRunData.likeValue
	arg0.galleryRunData.bgFilteValue = arg5 and arg5 or arg0.galleryRunData.bgFilteValue
end

function var0.updateMusicRunData(arg0, arg1, arg2, arg3)
	arg0.musicRunData.sortValue = arg1 and arg1 or arg0.musicRunData.sortValue
	arg0.musicRunData.middleIndex = arg2 and arg2 or arg0.musicRunData.middleIndex
	arg0.musicRunData.likeValue = arg3 and arg3 or arg0.musicRunData.likeValue
end

function var0.getGalleryRunData(arg0, arg1)
	return arg0.galleryRunData
end

function var0.getMusicRunData(arg0, arg1)
	return arg0.musicRunData
end

function var0.isPicNeedUnlockByID(arg0, arg1)
	local var0 = arg0:getPicUnlockMaterialByID(arg1)
	local var1 = arg0:getSinglePicConfigByID(arg1)

	if var1 then
		local var2 = var1.unlock_level

		if var2[1] == 1 and var2[2] == 0 then
			if #var0 == 0 then
				return false
			else
				return true
			end
		else
			return true
		end
	else
		assert(false, "不存在的插画ID:" .. arg1)
	end
end

function var0.isMusicNeedUnlockByID(arg0, arg1)
	local var0 = arg0:getMusicUnlockMaterialByID(arg1)
	local var1 = arg0:getSingleMusicConfigByID(arg1)

	if var1 then
		local var2 = var1.unlock_level

		if var2[1] == 1 and var2[2] == 0 then
			if #var0 == 0 then
				return false
			else
				return true
			end
		else
			return true
		end
	else
		assert(false, "不存在的音乐ID:" .. arg1)
	end
end

function var0.getPicUnlockMaterialByID(arg0, arg1)
	local var0 = arg0:getSinglePicConfigByID(arg1)

	if var0 then
		local var1 = var0.unlock_cost
		local var2 = {}

		for iter0, iter1 in ipairs(var1) do
			local var3 = {
				type = iter1[1],
				id = iter1[2],
				count = iter1[3]
			}

			var2[#var2 + 1] = var3
		end

		return var2
	else
		assert(false, "不存在的插画ID:" .. arg1)
	end
end

function var0.getMusicUnlockMaterialByID(arg0, arg1)
	local var0 = arg0:getSingleMusicConfigByID(arg1)

	if var0 then
		local var1 = var0.unlock_cost
		local var2 = {}

		for iter0, iter1 in ipairs(var1) do
			local var3 = {
				type = iter1[1],
				id = iter1[2],
				count = iter1[3]
			}

			var2[#var2 + 1] = var3
		end

		return var2
	else
		assert(false, "不存在的音乐ID:" .. arg1)
	end
end

function var0.isPicNeedUnlockMaterialByID(arg0, arg1)
	local var0 = arg0:getPicUnlockMaterialByID(arg1)

	if #var0 == 0 then
		return false
	else
		return var0
	end
end

function var0.isMusicNeedUnlockMaterialByID(arg0, arg1)
	local var0 = arg0:getMusicUnlockMaterialByID(arg1)

	if #var0 == 0 then
		return false
	else
		return var0
	end
end

function var0.getPicUnlockTipTextByID(arg0, arg1)
	local var0 = arg0:getSinglePicConfigByID(arg1)

	if var0 then
		return var0.illustrate
	else
		assert(false, "不存在的插画ID:" .. arg1)
	end
end

function var0.getMusicUnlockTipTextByID(arg0, arg1)
	local var0 = arg0:getSingleMusicConfigByID(arg1)

	if var0 then
		return var0.illustrate
	else
		assert(false, "不存在的音乐ID:" .. arg1)
	end
end

function var0.getResultForVer(arg0)
	return arg0.reForVer
end

function var0.clearVer(arg0)
	arg0.reForVer = nil
end

function var0.addPicIDToUnlockList(arg0, arg1)
	if table.contains(arg0.galleryPicUnLockIDLIst, arg1) then
		print("already exist picID:" .. arg1)
	else
		arg0.galleryPicUnLockIDLIst[#arg0.galleryPicUnLockIDLIst + 1] = arg1
	end
end

function var0.addMusicIDToUnlockList(arg0, arg1)
	if table.contains(arg0.musicUnLockIDLIst, arg1) then
		print("already exist musicID:" .. arg1)
	else
		arg0.musicUnLockIDLIst[#arg0.musicUnLockIDLIst + 1] = arg1
	end
end

function var0.addMangaIDToReadList(arg0, arg1)
	if table.contains(arg0.mangaReadIDList, arg1) then
		print("already exist mangaID:" .. arg1)
	else
		table.insert(arg0.mangaReadIDList, arg1)
	end
end

function var0.initMangaReadIDList(arg0, arg1)
	arg0.mangaReadIDList = {}

	for iter0, iter1 in ipairs(arg1) do
		for iter2 = 1, 32 do
			if bit.band(iter1, bit.lshift(1, iter2 - 1)) ~= 0 then
				local var0 = (iter0 - 1) * 32 + iter2

				arg0:addMangaIDToReadList(var0)
			end
		end
	end

	MangaConst.setVersionAndNewCount()
end

function var0.getMangaReadIDList(arg0)
	return arg0.mangaReadIDList
end

function var0.addMangaIDToLikeList(arg0, arg1)
	if table.contains(arg0.mangaLikeIDList, arg1) then
		print("already exist mangaID:" .. arg1)
	else
		table.insert(arg0.mangaLikeIDList, arg1)
	end
end

function var0.removeMangaIDFromLikeList(arg0, arg1)
	if table.contains(arg0.mangaLikeIDList, arg1) then
		table.removebyvalue(arg0.mangaLikeIDList, arg1, true)
	else
		print("not exist mangaID:" .. arg1)
	end
end

function var0.initMangaLikeIDList(arg0, arg1)
	arg0.mangaLikeIDList = {}

	for iter0, iter1 in ipairs(arg1) do
		for iter2 = 1, 32 do
			if bit.band(iter1, bit.lshift(1, iter2 - 1)) ~= 0 then
				local var0 = (iter0 - 1) * 32 + iter2

				arg0:addMangaIDToLikeList(var0)
			end
		end
	end
end

function var0.getMangaLikeIDList(arg0)
	return arg0.mangaLikeIDList
end

function var0.isPicUnlockedByID(arg0, arg1)
	if table.contains(arg0.galleryPicUnLockIDLIst, arg1) then
		return true
	else
		return false
	end
end

function var0.isMusicUnlockedByID(arg0, arg1)
	if table.contains(arg0.musicUnLockIDLIst, arg1) then
		return true
	else
		return false
	end
end

function var0.isPicUnlockableByID(arg0, arg1)
	local var0 = getProxy(PlayerProxy):getData().level
	local var1 = arg0:getSinglePicConfigByID(arg1)

	if var1 then
		local var2 = var1.unlock_level
		local var3 = var2[1]
		local var4 = var2[2]

		if var3 <= var0 then
			return true
		elseif var4 == GalleryConst.Still_Show_On_Lock then
			return false, true
		else
			return false, false
		end
	end
end

function var0.isMusicUnlockableByID(arg0, arg1)
	local var0 = getProxy(PlayerProxy):getData().level
	local var1 = arg0:getSingleMusicConfigByID(arg1)

	if var1 then
		local var2 = var1.unlock_level
		local var3 = var2[1]
		local var4 = var2[2]

		if var3 <= var0 then
			return true
		elseif var4 == MusicCollectionConst.Still_Show_On_Lock then
			return false, true
		else
			return false, false
		end
	end
end

function var0.addPicIDToLikeList(arg0, arg1)
	if table.contains(arg0.galleryPicLikeIDList, arg1) then
		print("already exist picID:" .. arg1)
	else
		arg0.galleryPicLikeIDList[#arg0.galleryPicLikeIDList + 1] = arg1
	end
end

function var0.removePicIDFromLikeList(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.galleryPicLikeIDList) do
		if iter1 == arg1 then
			table.remove(arg0.galleryPicLikeIDList, iter0)

			return
		end
	end

	print("no exist picID:" .. arg1)
end

function var0.isLikedByPicID(arg0, arg1)
	return table.contains(arg0.galleryPicLikeIDList, arg1)
end

function var0.addMusicIDToLikeList(arg0, arg1)
	if table.contains(arg0.musicLikeIDList, arg1) then
		print("already exist picID:" .. arg1)
	else
		arg0.musicLikeIDList[#arg0.musicLikeIDList + 1] = arg1
	end
end

function var0.removeMusicIDFromLikeList(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.musicLikeIDList) do
		if iter1 == arg1 then
			table.remove(arg0.musicLikeIDList, iter0)

			return
		end
	end

	print("no exist musicID:" .. arg1)
end

function var0.isLikedByMusicID(arg0, arg1)
	return table.contains(arg0.musicLikeIDList, arg1)
end

function var0.isGalleryHaveNewRes(arg0)
	if PlayerPrefs.GetInt("galleryVersion", 0) < GalleryConst.Version then
		return true
	else
		return false
	end
end

function var0.isMusicHaveNewRes(arg0)
	if PlayerPrefs.GetInt("musicVersion", 0) < MusicCollectionConst.Version then
		return true
	else
		return false
	end
end

function var0.isMangaHaveNewRes(arg0)
	if PlayerPrefs.GetInt("mangaVersion", 0) < MangaConst.Version then
		return true
	else
		return false
	end
end

return var0
