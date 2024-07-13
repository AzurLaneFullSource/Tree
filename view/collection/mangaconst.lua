MangaConst = {}

local var0_0 = MangaConst

var0_0.Version = 0
var0_0.NewCount = 0

function var0_0.setVersionAndNewCount()
	local var0_1 = #pg.cartoon.all
	local var1_1 = pg.cartoon.all[var0_1]

	var0_0.Version = pg.cartoon[var1_1].mark

	local var2_1 = 0

	for iter0_1 = var0_1, 1, -1 do
		local var3_1 = pg.cartoon.all[iter0_1]
		local var4_1 = pg.cartoon[var3_1].mark

		if var4_1 == var0_0.Version then
			var2_1 = var2_1 + 1
		elseif var4_1 < var0_0.Version then
			break
		end
	end

	var0_0.NewCount = var2_1
end

var0_0.MANGA_PATH_PREFIX = "mangapic/"
var0_0.SET_MANGA_LIKE = 0
var0_0.CANCEL_MANGA_LIKE = 1

function var0_0.isMangaEverReadByID(arg0_2)
	local var0_2 = getProxy(AppreciateProxy):getMangaReadIDList()

	return table.contains(var0_2, arg0_2)
end

function var0_0.isMangaNewByID(arg0_3)
	local var0_3 = pg.cartoon[arg0_3]

	assert(var0_3, "Manga info is null, ID:" .. tostring(arg0_3))

	return var0_3.mark >= var0_0.Version
end

function var0_0.isMangaLikeByID(arg0_4)
	local var0_4 = getProxy(AppreciateProxy):getMangaLikeIDList()

	return table.contains(var0_4, arg0_4)
end

return var0_0
