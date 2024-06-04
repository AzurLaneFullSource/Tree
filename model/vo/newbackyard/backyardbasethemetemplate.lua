local var0 = class("BackYardBaseThemeTemplate", import("..BaseVO"))

function var0.BuildId(arg0)
	return getProxy(PlayerProxy):getRawData().id .. arg0
end

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg1.id
	arg0.name = arg1.name or ""
	arg0.userId = arg1.user_id
	arg0.pos = arg1.pos
	arg0.player = arg1.player
	arg0.time = arg1.upload_time or 0
	arg0.collectionCnt = arg1.fav_count or 0
	arg0.likeCnt = arg1.like_count or 0
	arg0.isLike = arg1.is_like or 0
	arg0.isCollection = arg1.is_collection or 0
	arg0.desc = arg1.desc or ""
	arg0.rawPutList = arg1.furniture_put_list or {}
	arg0.imageMd5 = arg1.image_md5
	arg0.iconImageMd5 = arg1.icon_image_md5
	arg0.sortIndex = 0
	arg0.order = 0
end

function var0.GetSameFurnitureCnt(arg0, arg1)
	local var0 = 0
	local var1 = arg0:GetAllFurniture()

	for iter0, iter1 in pairs(var1) do
		if iter1.configId == arg1 then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.InitFurnitures(arg0, arg1)
	return RawData2ThemeConvertor.New():GenFurnitures(arg1)
end

function var0.GetMapSize(arg0)
	return (getProxy(DormProxy):getRawData():GetMapSize())
end

function var0.WarpPutInfo2BackYardFurnitrue(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg2 or {}) do
		local var0 = {}

		for iter2, iter3 in ipairs(iter1.child) do
			var0[tonumber(iter3.id)] = {
				x = iter3.x,
				y = iter3.y
			}
		end

		table.insert(arg0, BackyardThemeFurniture.New({
			id = tonumber(iter1.id),
			configId = iter1.configId or tonumber(iter1.id),
			position = {
				x = iter1.x,
				y = iter1.y
			},
			dir = iter1.dir,
			child = var0,
			parent = tonumber(iter1.parent),
			floor = arg1
		}))
	end
end

function var0.SetSortIndex(arg0, arg1)
	arg0.sortIndex = arg1
end

function var0.GetType(arg0)
	assert(false)
end

function var0.IsSelfUsage(arg0)
	return arg0:GetType() == BackYardConst.THEME_TEMPLATE_USAGE_TYPE_SELF
end

function var0.GetUserId(arg0)
	return arg0.userId
end

function var0.SetPlayerInfo(arg0, arg1)
	arg0.player = arg1
end

function var0.ExistPlayerInfo(arg0)
	return arg0.player ~= nil
end

function var0.GetUploadTime(arg0)
	if arg0.time > 0 then
		return pg.TimeMgr.GetInstance():STimeDescC(arg0.time, "%Y/%m/%d")
	else
		return ""
	end
end

function var0.IsPushed(arg0)
	return arg0.time > 0
end

function var0.GetLikeCnt(arg0)
	if arg0.likeCnt > 99999 then
		return "99999+"
	else
		return arg0.likeCnt
	end
end

function var0.GetCollectionCnt(arg0)
	if arg0.collectionCnt > 99999 then
		return "99999+"
	else
		return arg0.collectionCnt
	end
end

function var0.IsLiked(arg0)
	return arg0.isLike == 1
end

function var0.IsCollected(arg0)
	return arg0.isCollection == 1
end

function var0.CancelCollection(arg0)
	if arg0:IsCollected() then
		arg0.isCollection = 0
		arg0.collectionCnt = arg0.collectionCnt - 1
	end
end

function var0.AddCollection(arg0)
	if not arg0:IsCollected() then
		arg0.isCollection = 1
		arg0.collectionCnt = arg0.collectionCnt + 1
	end
end

function var0.AddLike(arg0)
	if not arg0:IsLiked() then
		arg0.isLike = 1
		arg0.likeCnt = arg0.likeCnt + 1
	end
end

function var0.ExistLocalImage(arg0)
	local function var0()
		local var0 = BackYardBaseThemeTemplate.BuildId(arg0.pos)
		local var1 = BackYardThemeTempalteUtil.GetMd5(var0)
		local var2 = BackYardThemeTempalteUtil.GetIconMd5(var0)

		return var1 == arg0.imageMd5 and var2 == arg0.iconImageMd5
	end

	return BackYardThemeTempalteUtil.FileExists(arg0.id) and var0()
end

function var0.GetRawPutList(arg0)
	return arg0.rawPutList
end

function var0.GetName(arg0)
	return arg0.name
end

function var0.GetDesc(arg0)
	return arg0.desc
end

function var0.GetTextureName(arg0)
	return arg0.id
end

function var0.GetTextureIconName(arg0)
	return arg0.id .. "_icon"
end

function var0.GetPos(arg0)
	return arg0.pos
end

function var0.ShouldFetch(arg0)
	return false
end

function var0.ShouldFetch(arg0)
	return false
end

function var0.IsPurchased(arg0)
	return true
end

function var0.GetImageMd5(arg0)
	return arg0.imageMd5
end

function var0.GetIconMd5(arg0)
	return arg0.iconImageMd5
end

function var0.UpdateIconMd5(arg0, arg1)
	arg0.iconImageMd5 = arg1
end

function var0.GetAllFurniture(arg0)
	assert(false, "请重写我")
end

function var0.GetWarpFurnitures(arg0)
	local var0 = {}
	local var1 = arg0:GetAllFurniture()

	for iter0, iter1 in pairs(var1) do
		table.insert(var0, iter1)
	end

	return var0
end

function var0.GetFurnitureCnt(arg0)
	assert(false, "请重写我")
end

function var0.IsOccupyed(arg0, arg1, arg2)
	local var0 = arg0:GetAllFurniture()

	for iter0, iter1 in pairs(var0) do
		local var1 = arg1[iter1.id]

		if var1 and var1.floor ~= 0 and var1.floor ~= arg2 then
			return true
		end
	end

	return false
end

function var0.GetUsableFurnituresForFloor(arg0, arg1, arg2)
	local var0 = {}
	local var1 = {}

	for iter0, iter1 in pairs(arg1) do
		if iter1.floor ~= arg2 then
			var1[iter1.id] = iter1
		end
	end

	local var2 = arg0:GetAllFurniture()
	local var3 = {}
	local var4 = {}

	for iter2, iter3 in pairs(var2) do
		if var1[iter3.id] then
			table.insert(var3, iter3.id)

			for iter4, iter5 in pairs(iter3.child) do
				table.insert(var3, iter4)
			end

			if tonumber(iter3.parent) ~= 0 then
				table.insert(var3, tonumber(iter3.parent))

				local var5 = var2[tonumber(iter3.parent)]

				for iter6, iter7 in pairs(var5.child) do
					table.insert(var3, iter6)
				end
			end
		else
			table.insert(var4, iter3.id)
		end
	end

	for iter8, iter9 in ipairs(var4) do
		if not table.contains(var3, iter9) then
			table.insert(var0, var2[iter9])
		end
	end

	return var0
end

function var0.OwnThemeTemplateFurniture(arg0)
	local var0 = getProxy(DormProxy):getRawData():GetPurchasedFurnitures()

	local function var1(arg0, arg1)
		local var0 = var0[arg0]

		return var0 and arg1 <= var0.count
	end

	for iter0, iter1 in pairs(arg0:GetFurnitureCnt()) do
		if not var1(iter0, iter1) then
			return false
		end
	end

	return true
end

function var0.MatchSearchKey(arg0, arg1)
	if not arg1 or arg1 == "" then
		return true
	else
		arg1 = string.lower(arg1)

		local function var0(arg0)
			local var0 = arg0:GetName()
			local var1 = string.lower(var0)

			return string.find(var1, arg0)
		end

		local function var1(arg0)
			local var0 = arg0:GetDesc()
			local var1 = string.lower(var0)

			return string.find(var1, arg0)
		end

		return var0(arg1) or var1(arg1)
	end
end

return var0
