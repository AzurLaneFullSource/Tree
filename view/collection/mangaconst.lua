MangaConst = {}

local var0 = MangaConst

var0.Version = 0
var0.NewCount = 0

function var0.setVersionAndNewCount()
	local var0 = #pg.cartoon.all
	local var1 = pg.cartoon.all[var0]

	var0.Version = pg.cartoon[var1].mark

	local var2 = 0

	for iter0 = var0, 1, -1 do
		local var3 = pg.cartoon.all[iter0]
		local var4 = pg.cartoon[var3].mark

		if var4 == var0.Version then
			var2 = var2 + 1
		elseif var4 < var0.Version then
			break
		end
	end

	var0.NewCount = var2
end

var0.MANGA_PATH_PREFIX = "mangapic/"
var0.SET_MANGA_LIKE = 0
var0.CANCEL_MANGA_LIKE = 1

function var0.isMangaEverReadByID(arg0)
	local var0 = getProxy(AppreciateProxy):getMangaReadIDList()

	return table.contains(var0, arg0)
end

function var0.isMangaNewByID(arg0)
	local var0 = pg.cartoon[arg0]

	assert(var0, "Manga info is null, ID:" .. tostring(arg0))

	return var0.mark >= var0.Version
end

function var0.isMangaLikeByID(arg0)
	local var0 = getProxy(AppreciateProxy):getMangaLikeIDList()

	return table.contains(var0, arg0)
end

return var0
