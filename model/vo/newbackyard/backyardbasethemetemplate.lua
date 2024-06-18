local var0_0 = class("BackYardBaseThemeTemplate", import("..BaseVO"))

function var0_0.BuildId(arg0_1)
	return getProxy(PlayerProxy):getRawData().id .. arg0_1
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.id = arg1_2.id
	arg0_2.configId = arg1_2.id
	arg0_2.name = arg1_2.name or ""
	arg0_2.userId = arg1_2.user_id
	arg0_2.pos = arg1_2.pos
	arg0_2.player = arg1_2.player
	arg0_2.time = arg1_2.upload_time or 0
	arg0_2.collectionCnt = arg1_2.fav_count or 0
	arg0_2.likeCnt = arg1_2.like_count or 0
	arg0_2.isLike = arg1_2.is_like or 0
	arg0_2.isCollection = arg1_2.is_collection or 0
	arg0_2.desc = arg1_2.desc or ""
	arg0_2.rawPutList = arg1_2.furniture_put_list or {}
	arg0_2.imageMd5 = arg1_2.image_md5
	arg0_2.iconImageMd5 = arg1_2.icon_image_md5
	arg0_2.sortIndex = 0
	arg0_2.order = 0
end

function var0_0.GetSameFurnitureCnt(arg0_3, arg1_3)
	local var0_3 = 0
	local var1_3 = arg0_3:GetAllFurniture()

	for iter0_3, iter1_3 in pairs(var1_3) do
		if iter1_3.configId == arg1_3 then
			var0_3 = var0_3 + 1
		end
	end

	return var0_3
end

function var0_0.InitFurnitures(arg0_4, arg1_4)
	return RawData2ThemeConvertor.New():GenFurnitures(arg1_4)
end

function var0_0.GetMapSize(arg0_5)
	return (getProxy(DormProxy):getRawData():GetMapSize())
end

function var0_0.WarpPutInfo2BackYardFurnitrue(arg0_6, arg1_6, arg2_6)
	for iter0_6, iter1_6 in ipairs(arg2_6 or {}) do
		local var0_6 = {}

		for iter2_6, iter3_6 in ipairs(iter1_6.child) do
			var0_6[tonumber(iter3_6.id)] = {
				x = iter3_6.x,
				y = iter3_6.y
			}
		end

		table.insert(arg0_6, BackyardThemeFurniture.New({
			id = tonumber(iter1_6.id),
			configId = iter1_6.configId or tonumber(iter1_6.id),
			position = {
				x = iter1_6.x,
				y = iter1_6.y
			},
			dir = iter1_6.dir,
			child = var0_6,
			parent = tonumber(iter1_6.parent),
			floor = arg1_6
		}))
	end
end

function var0_0.SetSortIndex(arg0_7, arg1_7)
	arg0_7.sortIndex = arg1_7
end

function var0_0.GetType(arg0_8)
	assert(false)
end

function var0_0.IsSelfUsage(arg0_9)
	return arg0_9:GetType() == BackYardConst.THEME_TEMPLATE_USAGE_TYPE_SELF
end

function var0_0.GetUserId(arg0_10)
	return arg0_10.userId
end

function var0_0.SetPlayerInfo(arg0_11, arg1_11)
	arg0_11.player = arg1_11
end

function var0_0.ExistPlayerInfo(arg0_12)
	return arg0_12.player ~= nil
end

function var0_0.GetUploadTime(arg0_13)
	if arg0_13.time > 0 then
		return pg.TimeMgr.GetInstance():STimeDescC(arg0_13.time, "%Y/%m/%d")
	else
		return ""
	end
end

function var0_0.IsPushed(arg0_14)
	return arg0_14.time > 0
end

function var0_0.GetLikeCnt(arg0_15)
	if arg0_15.likeCnt > 99999 then
		return "99999+"
	else
		return arg0_15.likeCnt
	end
end

function var0_0.GetCollectionCnt(arg0_16)
	if arg0_16.collectionCnt > 99999 then
		return "99999+"
	else
		return arg0_16.collectionCnt
	end
end

function var0_0.IsLiked(arg0_17)
	return arg0_17.isLike == 1
end

function var0_0.IsCollected(arg0_18)
	return arg0_18.isCollection == 1
end

function var0_0.CancelCollection(arg0_19)
	if arg0_19:IsCollected() then
		arg0_19.isCollection = 0
		arg0_19.collectionCnt = arg0_19.collectionCnt - 1
	end
end

function var0_0.AddCollection(arg0_20)
	if not arg0_20:IsCollected() then
		arg0_20.isCollection = 1
		arg0_20.collectionCnt = arg0_20.collectionCnt + 1
	end
end

function var0_0.AddLike(arg0_21)
	if not arg0_21:IsLiked() then
		arg0_21.isLike = 1
		arg0_21.likeCnt = arg0_21.likeCnt + 1
	end
end

function var0_0.ExistLocalImage(arg0_22)
	local function var0_22()
		local var0_23 = BackYardBaseThemeTemplate.BuildId(arg0_22.pos)
		local var1_23 = BackYardThemeTempalteUtil.GetMd5(var0_23)
		local var2_23 = BackYardThemeTempalteUtil.GetIconMd5(var0_23)

		return var1_23 == arg0_22.imageMd5 and var2_23 == arg0_22.iconImageMd5
	end

	return BackYardThemeTempalteUtil.FileExists(arg0_22.id) and var0_22()
end

function var0_0.GetRawPutList(arg0_24)
	return arg0_24.rawPutList
end

function var0_0.GetName(arg0_25)
	return arg0_25.name
end

function var0_0.GetDesc(arg0_26)
	return arg0_26.desc
end

function var0_0.GetTextureName(arg0_27)
	return arg0_27.id
end

function var0_0.GetTextureIconName(arg0_28)
	return arg0_28.id .. "_icon"
end

function var0_0.GetPos(arg0_29)
	return arg0_29.pos
end

function var0_0.ShouldFetch(arg0_30)
	return false
end

function var0_0.ShouldFetch(arg0_31)
	return false
end

function var0_0.IsPurchased(arg0_32)
	return true
end

function var0_0.GetImageMd5(arg0_33)
	return arg0_33.imageMd5
end

function var0_0.GetIconMd5(arg0_34)
	return arg0_34.iconImageMd5
end

function var0_0.UpdateIconMd5(arg0_35, arg1_35)
	arg0_35.iconImageMd5 = arg1_35
end

function var0_0.GetAllFurniture(arg0_36)
	assert(false, "请重写我")
end

function var0_0.GetWarpFurnitures(arg0_37)
	local var0_37 = {}
	local var1_37 = arg0_37:GetAllFurniture()

	for iter0_37, iter1_37 in pairs(var1_37) do
		table.insert(var0_37, iter1_37)
	end

	return var0_37
end

function var0_0.GetFurnitureCnt(arg0_38)
	assert(false, "请重写我")
end

function var0_0.IsOccupyed(arg0_39, arg1_39, arg2_39)
	local var0_39 = arg0_39:GetAllFurniture()

	for iter0_39, iter1_39 in pairs(var0_39) do
		local var1_39 = arg1_39[iter1_39.id]

		if var1_39 and var1_39.floor ~= 0 and var1_39.floor ~= arg2_39 then
			return true
		end
	end

	return false
end

function var0_0.GetUsableFurnituresForFloor(arg0_40, arg1_40, arg2_40)
	local var0_40 = {}
	local var1_40 = {}

	for iter0_40, iter1_40 in pairs(arg1_40) do
		if iter1_40.floor ~= arg2_40 then
			var1_40[iter1_40.id] = iter1_40
		end
	end

	local var2_40 = arg0_40:GetAllFurniture()
	local var3_40 = {}
	local var4_40 = {}

	for iter2_40, iter3_40 in pairs(var2_40) do
		if var1_40[iter3_40.id] then
			table.insert(var3_40, iter3_40.id)

			for iter4_40, iter5_40 in pairs(iter3_40.child) do
				table.insert(var3_40, iter4_40)
			end

			if tonumber(iter3_40.parent) ~= 0 then
				table.insert(var3_40, tonumber(iter3_40.parent))

				local var5_40 = var2_40[tonumber(iter3_40.parent)]

				for iter6_40, iter7_40 in pairs(var5_40.child) do
					table.insert(var3_40, iter6_40)
				end
			end
		else
			table.insert(var4_40, iter3_40.id)
		end
	end

	for iter8_40, iter9_40 in ipairs(var4_40) do
		if not table.contains(var3_40, iter9_40) then
			table.insert(var0_40, var2_40[iter9_40])
		end
	end

	return var0_40
end

function var0_0.OwnThemeTemplateFurniture(arg0_41)
	local var0_41 = getProxy(DormProxy):getRawData():GetPurchasedFurnitures()

	local function var1_41(arg0_42, arg1_42)
		local var0_42 = var0_41[arg0_42]

		return var0_42 and arg1_42 <= var0_42.count
	end

	for iter0_41, iter1_41 in pairs(arg0_41:GetFurnitureCnt()) do
		if not var1_41(iter0_41, iter1_41) then
			return false
		end
	end

	return true
end

function var0_0.MatchSearchKey(arg0_43, arg1_43)
	if not arg1_43 or arg1_43 == "" then
		return true
	else
		arg1_43 = string.lower(arg1_43)

		local function var0_43(arg0_44)
			local var0_44 = arg0_43:GetName()
			local var1_44 = string.lower(var0_44)

			return string.find(var1_44, arg0_44)
		end

		local function var1_43(arg0_45)
			local var0_45 = arg0_43:GetDesc()
			local var1_45 = string.lower(var0_45)

			return string.find(var1_45, arg0_45)
		end

		return var0_43(arg1_43) or var1_43(arg1_43)
	end
end

return var0_0
