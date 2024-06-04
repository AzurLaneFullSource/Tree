local var0 = class("WorldCollectionProxy", import("....BaseEntity"))

var0.Fields = {
	storyGroup = "table",
	data = "table",
	placeGroup = "table"
}
var0.EventPlaceUnlock = "WorldCollectionProxy.EventPlaceUnlock"
var0.WorldCollectionType = {
	FILE = 1,
	RECORD = 2
}
var0.WorldCollectionTemplate = {}
var0.WorldCollectionTemplateExtend = {}

for iter0, iter1 in ipairs(pg.world_collection_file_template.all) do
	local var1 = pg.world_collection_file_template[iter1]

	if var0.WorldCollectionTemplate[iter1] ~= nil then
		assert(false, "Repeat Collection UID " .. iter1)
	end

	var0.WorldCollectionTemplate[iter1] = var1
	var0.WorldCollectionTemplateExtend[iter1] = var0.WorldCollectionTemplateExtend[iter1] or {}
	var0.WorldCollectionTemplateExtend[iter1].type = var0.WorldCollectionType.FILE
end

for iter2, iter3 in ipairs(pg.world_collection_file_group.all) do
	local var2 = pg.world_collection_file_group[iter3]

	for iter4, iter5 in ipairs(var2.child) do
		if var0.WorldCollectionTemplate[iter5] ~= nil then
			var0.WorldCollectionTemplateExtend[iter5].group = var2.id
		else
			assert(false, "Missing Collection FILE UID " .. iter5)
		end
	end
end

for iter6, iter7 in ipairs(pg.world_collection_record_template.all) do
	local var3 = pg.world_collection_record_template[iter7]

	if var0.WorldCollectionTemplate[iter7] ~= nil then
		assert(false, "Repeat Collection UID " .. iter7)
	end

	var0.WorldCollectionTemplate[iter7] = var3
	var0.WorldCollectionTemplateExtend[iter7] = var0.WorldCollectionTemplateExtend[iter7] or {}
	var0.WorldCollectionTemplateExtend[iter7].type = var0.WorldCollectionType.RECORD
end

for iter8, iter9 in ipairs(pg.world_collection_record_group.all) do
	local var4 = pg.world_collection_record_group[iter9]

	for iter10, iter11 in ipairs(var4.child) do
		if var0.WorldCollectionTemplate[iter11] ~= nil then
			var0.WorldCollectionTemplateExtend[iter11].group = var4.id
		else
			assert(false, "Missing Collection RECORD UID " .. iter11)
		end
	end
end

function var0.GetCollectionTemplate(arg0)
	local var0 = var0.WorldCollectionTemplate[arg0]

	assert(var0, "Missing WorldCollection Config ID: " .. (arg0 or "NIL"))

	return var0
end

function var0.GetCollectionType(arg0)
	local var0 = var0.WorldCollectionTemplateExtend[arg0]

	assert(var0 and var0.type, "Missing WorldCollection Type ID: " .. (arg0 or "NIL"))

	return var0.type
end

function var0.GetCollectionGroup(arg0)
	local var0 = var0.WorldCollectionTemplateExtend[arg0]

	assert(var0 and var0.group, "Missing WorldCollection Type ID: " .. (arg0 or "NIL"))

	return var0.group
end

function var0.GetCollectionFileGroupTemplate(arg0)
	local var0 = pg.world_collection_file_group[arg0]

	assert(var0, "Missing world_collection_file_group Config ID: " .. (arg0 or "NIL"))

	return var0
end

function var0.GetCollectionFileTemplate(arg0)
	local var0 = pg.world_collection_file_template[arg0]

	assert(var0, "Missing world_collection_file_template Config ID: " .. (arg0 or "NIL"))

	return var0
end

function var0.GetCollectionRecordGroupTemplate(arg0)
	local var0 = pg.world_collection_record_group[arg0]

	assert(var0, "Missing world_collection_record_group Config ID: " .. (arg0 or "NIL"))

	return var0
end

function var0.GetCollectionRecordTemplate(arg0)
	local var0 = pg.world_collection_record_template[arg0]

	assert(var0, "Missing world_collection_record_template Config ID: " .. (arg0 or "NIL"))

	return var0
end

function var0.Setup(arg0, arg1)
	arg0.data = {}

	for iter0, iter1 in ipairs(arg1) do
		arg0.data[iter1] = true
	end
end

function var0.Unlock(arg0, arg1)
	if not arg0.data[arg1] then
		arg0.data[arg1] = true
	end
end

function var0.IsUnlock(arg0, arg1)
	return tobool(arg0.data[arg1])
end

return var0
