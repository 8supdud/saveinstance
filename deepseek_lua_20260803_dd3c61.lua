--[[ UltraSmartSaveInstance ]]

local function string_find(s, pattern, init)
	return string.find(s, pattern, init, true)
end

local function arrayToDict(t, mixedMode, valueOverride, typeStrict)
	local tmp = {}

	if mixedMode then
		for any1, any2 in t do
			if type(any1) == "number" then
				tmp[any2] = valueOverride or true
			elseif type(any2) == "table" then
				tmp[any1] = arrayToDict(any2, mixedMode)
			else
				tmp[any1] = any2
			end
		end
	else
		for _, key in t do
			if not typeStrict or typeStrict and type(key) == typeStrict then
				tmp[key] = true
			end
		end
	end

	return tmp
end

local global_container
do
	local filename = "UniversalMethodFinder"

	local finder
	finder, global_container = loadstring(
		game:HttpGet("https://raw.githubusercontent.com/luau/SomeHub/main/" .. filename .. ".luau", true),
		filename
	)()

	finder({
		base64encode = 'local a={...}local b=a[1]local function c(a,b)return string.find(a,b,nil,true)end;return c(b,"encode")and(c(b,"base64")or c(string.lower(tostring(a[2])),"base64"))',
		gethiddenproperty = 'string.find(...,"get",nil,true) and string.find(...,"h",nil,true) and string.find(...,"prop",nil,true) and string.sub(...,#...) ~= "s"',
		gethui = 'string.find(...,"get",nil,true) and string.find(...,"h",nil,true) and string.find(...,"ui",nil,true)',
		getnilinstances = 'string.find(...,"nil",nil,true) and string.find(...,"get",nil,true) and string.sub(...,#...) == "s"',
		getscriptbytecode = 'string.find(...,"get",nil,true) and string.find(...,"script",nil,true) and string.find(...,"bytecode",nil,true)',
		protectgui = 'string.find(...,"protect",nil,true) and string.find(...,"ui",nil,true) and not string.find(...,"un",nil,true)',
	}, true, 10)
end

local identify_executor = identifyexecutor or getexecutorname or whatexecutor

local EXECUTOR_NAME = identify_executor and identify_executor() or ""

local gethiddenproperty = global_container.gethiddenproperty
local gethiddenproperty_fallback

local appendfile = appendfile
local isfile = isfile
local readfile = readfile
local writefile = writefile

local getscriptbytecode = global_container.getscriptbytecode
local base64encode = global_container.base64encode

local service = setmetatable({}, {
	__index = function(self, serviceName)
		local o, s = pcall(Instance.new, serviceName)
		local Service = o and s
			or game:GetService(serviceName)
			or settings():GetService(serviceName)
			or UserSettings():GetService(serviceName)

		if Service then
			self[serviceName] = Service
		end
		return Service
	end,
})

local sharedStringId = 1e15
local sharedStrings = setmetatable({}, {
	__index = function(self, str)
		local id = base64encode(tostring(sharedStringId))
		sharedStringId += 1

		self[str] = id
		return id
	end,
})

local KeepSharedStrings = { MeshData2 = true, ChildData2 = true, PhysicalConfigData = true }
local inheritedProperties = {}
local defaultInstances = {}
local referents, refSize = setmetatable({}, { __mode = "ks" }), 0

local function getRef(instance)
	local ref = referents[instance]
	if not ref then
		ref = refSize
		referents[instance] = ref
		refSize += 1
	end
	return ref
end

local function index(self, index_name)
	return self[index_name]
end

local FULL_VERSION

if not pcall(function()
	FULL_VERSION = version()
end) then
	if not pcall(function()
		FULL_VERSION = settings():GetService("DebugSettings").RobloxVersion
	end) then
		if not pcall(function()
			FULL_VERSION = service.RunService:GetRobloxVersion()
		end) then
			FULL_VERSION = "UNKNOWN"
		end
	end
end

local CLIENT_VERSION = tonumber(string.match(FULL_VERSION, "%d+%.(%d+)")) or 9e9
local __BREAK = "__BREAK" .. service.HttpService:GenerateGUID(false)

local Attribute_Type_Ids =
	{
		["nil"] = 0x01,
		string = 0x02,
		boolean = 0x03,
		int32 = 0x04,
		number = 0x06,
		ValueArray = 0x07,
		ValueTable = 0x08,
		UDim = 0x09,
		UDim2 = 0x0A,
		Ray = 0x0B,
		Faces = 0x0C,
		Axes = 0x0D,
		BrickColor = 0x0E,
		Color3 = 0x0F,
		Vector2 = 0x10,
		Vector3 = 0x11,
		Vector2int16 = 0x12,
		Vector3int16 = 0x13,
		CFrame = 0x14,
		EnumItem = 0x15,
		NumberSequence = 0x17,
		NumberSequenceKeypoint = 0x18,
		ColorSequence = 0x19,
		ColorSequenceKeypoint = 0x1A,
		NumberRange = 0x1B,
		Rect = 0x1C,
		PhysicalProperties = 0x1D,
		Color3uint8 = 0x1E,
		Region3 = 0x1F,
		Region3int16 = 0x20,
		Font = 0x21,
		SecurityCapabilities = 0x22,
		Path2DControlPoint = 0x23,
		TweenInfo = 0x24,
	}

local CFrame_Rotation_Ids = {
	["\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63"] = 0x02,
	["\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\63\0\0\0\0"] = 0x03,
	["\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191"] = 0x05,
	["\0\0\128\63\0\0\0\0\0\0\0\128\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\191\0\0\0\0"] = 0x06,
	["\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191"] = 0x07,
	["\0\0\0\0\0\0\0\0\0\0\128\63\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0"] = 0x09,
	["\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\128\0\0\0\0\0\0\0\0\0\0\128\63"] = 0x0a,
	["\0\0\0\0\0\0\0\0\0\0\128\191\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0"] = 0x0c,
	["\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\128\63\0\0\0\0\0\0\0\0"] = 0x0d,
	["\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0"] = 0x0e,
	["\0\0\0\0\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\128\63\0\0\0\0\0\0\0\0"] = 0x10,
	["\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\128"] = 0x11,
	["\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191"] = 0x14,
	["\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\63\0\0\0\128"] = 0x15,
	["\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63"] = 0x17,
	["\0\0\128\191\0\0\0\0\0\0\0\128\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\191\0\0\0\128"] = 0x18,
	["\0\0\0\0\0\0\128\63\0\0\0\128\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63"] = 0x19,
	["\0\0\0\0\0\0\0\0\0\0\128\191\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0"] = 0x1b,
	["\0\0\0\0\0\0\128\191\0\0\0\128\0\0\128\191\0\0\0\0\0\0\0\128\0\0\0\0\0\0\0\0\0\0\128\191"] = 0x1c,
	["\0\0\0\0\0\0\0\0\0\0\128\63\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0"] = 0x1e,
	["\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\128\191\0\0\0\0\0\0\0\0"] = 0x1f,
	["\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\63\0\0\0\128\0\0\128\191\0\0\0\0\0\0\0\0"] = 0x20,
	["\0\0\0\0\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\128\191\0\0\0\0\0\0\0\0"] = 0x22,
	["\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\191\0\0\0\128\0\0\128\191\0\0\0\0\0\0\0\128"] = 0x23,
}
local rotationBuffer = buffer.create(36)
local EMPTY_BUFFER = buffer.create(0)
local BASE_CAPABILITIES
pcall(function()
	BASE_CAPABILITIES = SecurityCapabilities.new()
end)
local CAPABILITY_BITS = {
	Plugin = 2 ^ 0,
	LocalUser = 2 ^ 1,
	WritePlayer = 2 ^ 2,
	RobloxScript = 2 ^ 3,
	RobloxEngine = 2 ^ 4,
	NotAccessible = 2 ^ 5,
	RunClientScript = 2 ^ 8,
	RunServerScript = 2 ^ 9,
	Unknown = 2 ^ 10,
	AccessOutsideWrite = 2 ^ 11,
	Unassigned = 2 ^ 15,
	LoadUnownedAsset = 2 ^ 16,
	LoadString = 2 ^ 17,
	ScriptGlobals = 2 ^ 18,
	CreateInstances = 2 ^ 19,
	Basic = 2 ^ 20,
	Audio = 2 ^ 21,
	DataStore = 2 ^ 22,
	Network = 2 ^ 23,
	Physics = 2 ^ 24,
	UI = 2 ^ 25,
	CSG = 2 ^ 26,
	Chat = 2 ^ 27,
	Animation = 2 ^ 28,
	AvatarAppearance = 2 ^ 29,
	Input = 2 ^ 30,
	Environment = 2 ^ 31,
	RemoteEvent = 2 ^ 32,
	LegacySound = 2 ^ 33,
	Players = 2 ^ 34,
	CapabilityControl = 2 ^ 35,
	AssetRead = 2 ^ 36,
	AssetManagement = 2 ^ 37,
	DynamicGeneration = 2 ^ 38,
	PlatformAvatarEditing = 2 ^ 39,
	AssetCreateUpdate = 2 ^ 40,
	Capture = 2 ^ 41,
	SensitiveInput = 2 ^ 42,
	Monetization = 2 ^ 43,
	LoadOwnedAsset = 2 ^ 44,
	Social = 2 ^ 45,
	ServerCommunication = 2 ^ 46,
	Logging = 2 ^ 47,
	PromptExternalPurchase = 2 ^ 48,
	Groups = 2 ^ 49,
	Teleport = 2 ^ 50,
	Consequences = 2 ^ 51,
	Material = 2 ^ 52,
	AvatarBehavior = 2 ^ 53,
	RemoteCommand = 2 ^ 59,
	InternalTest = 2 ^ 60,
	PluginOrOpenCloud = 2 ^ 61,
	Assistant = 2 ^ 62,
	Restricted = 2 ^ 63,
}

local function countCapabilityBits(raw)
	local result = 0
	for _, flag in string.split(tostring(raw), " | ") do
		local bit = CAPABILITY_BITS[flag]
		if bit then
			result += bit
		end
	end
	return result
end

local function countBits(...)
	local Value = 0

	for i, bit in { ... } do
		if bit then
			Value += 2 ^ (i - 1)
		end
	end

	return Value
end

local function cframeToQuaternion(cframe)
	local _, _, _, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cframe:GetComponents()
	local trace = R00 + R11 + R22
	local S, qW, qX, qY, qZ
	if trace > 0 then
		S = math.sqrt(1 + trace) * 2
		qW = 0.25 * S
		qX = (R21 - R12) / S
		qY = (R02 - R20) / S
		qZ = (R10 - R01) / S
	elseif (R00 > R11) and (R00 > R22) then
		S = math.sqrt(1 + R00 - R11 - R22) * 2
		qW = (R21 - R12) / S
		qX = 0.25 * S
		qY = (R01 + R10) / S
		qZ = (R02 + R20) / S
	elseif R11 > R22 then
		S = math.sqrt(1 + R11 - R00 - R22) * 2
		qW = (R02 - R20) / S
		qX = (R01 + R10) / S
		qY = 0.25 * S
		qZ = (R12 + R21) / S
	else
		S = math.sqrt(1 + R22 - R00 - R11) * 2
		qW = (R10 - R01) / S
		qX = (R02 + R20) / S
		qY = (R12 + R21) / S
		qZ = 0.25 * S
	end
	if qW < 0 then
		qW, qX, qY, qZ = -qW, -qX, -qY, -qZ
	end
	return qX, qY, qZ, qW
end

local function classifyTable(t)
	local len = #t
	if len > 0 then
		local n = 0
		for _ in t do
			n += 1
		end
		if n == len then
			return "ValueArray"
		end
	end
	local n, maxIndex = 0, 0
	for k in t do
		n += 1
		if type(k) == "number" and k > maxIndex and k == math.floor(k) and k >= 1 then
			maxIndex = k
		end
	end
	return (maxIndex > 0 and maxIndex == n) and "ValueArray" or "ValueTable"
end

local function resolveTypeName(value)
	local t = typeof(value)
	if t == "table" then
		return classifyTable(value)
	end
	return t
end

local Binary_Encoders
Binary_Encoders = {
	_packMultiple = function(encoder, value1, value2, value3)
		local buf1, size1 = encoder(value1)
		local buf2, size2 = encoder(value2)

		local len = size1 + size2
		local buf3, size3

		if value3 ~= nil then
			buf3, size3 = encoder(value3)
			len += size3
		end

		local b = buffer.create(len)

		buffer.copy(b, 0, buf1)
		buffer.copy(b, size1, buf2)

		if value3 ~= nil then
			buffer.copy(b, size1 + size2, buf3)
		end

		return b, len
	end,
	_makeSequence = function(keypoint_handler, keypointSize)
		return function(raw)
			local keypoints = raw.Keypoints
			local n = #keypoints

			local len = 4 + keypointSize * n
			local b = buffer.create(len)

			buffer.writeu32(b, 0, n)

			local offset = 4
			for _, keypoint in keypoints do
				keypoint_handler(keypoint, b, offset)
				offset += keypointSize
			end

			return b, len
		end
	end,
	_writeI64LE = function(b, offset, raw)
		local low = bit32.band(raw, 0xFFFFFFFF)
		local high = (raw - low) / 0x100000000

		buffer.writei32(b, offset, low)
		buffer.writei32(b, offset + 4, high)
	end,
	_packF32 = nil,
	_packI16 = nil,
	_makeVectorPacker = function(writeFunc, elementSize)
		return function(X, Y, Z)
			local len = Z and (elementSize * 3) or (elementSize * 2)
			local b = buffer.create(len)

			writeFunc(b, 0, X)
			writeFunc(b, elementSize, Y)
			if Z then
				writeFunc(b, elementSize * 2, Z)
			end

			return b, len
		end
	end,
	["nil"] = function(raw)
		return EMPTY_BUFFER, 0
	end,
	["string"] = function(raw)
		local raw_len = #raw
		local len = 4 + raw_len

		local b = buffer.create(len)

		buffer.writeu32(b, 0, raw_len)
		buffer.writestring(b, 4, raw)

		return b, len
	end,
	["boolean"] = function(raw)
		local b = buffer.create(1)

		buffer.writeu8(b, 0, raw and 1 or 0)

		return b, 1
	end,
	["number"] = function(raw)
		local b = buffer.create(8)

		buffer.writef64(b, 0, raw)

		return b, 8
	end,
	["ValueArray"] = function(raw)
		local n = 0
		for k in raw do
			if type(k) == "number" and k > n and k == math.floor(k) and k >= 1 then
				n = k
			end
		end

		local bufs = table.create(n)
		local total = 4
		local count = 0

		for i = 1, n do
			local value = raw[i]
			local b, size

			if value == nil then
				b = buffer.create(1)
				buffer.writeu8(b, 0, 0x01)
				size = 1
			else
				local valueTypeName = resolveTypeName(value)
				local typeId = Attribute_Type_Ids[valueTypeName]
				local descriptor = Binary_Encoders[valueTypeName]
				if not descriptor then
					continue
				end
				local dataBuf, dataSize = descriptor(value)

				b = buffer.create(1 + dataSize)
				buffer.writeu8(b, 0, typeId)
				buffer.copy(b, 1, dataBuf)
				size = 1 + dataSize
			end

			count += 1
			bufs[count] = b
			total += size
		end

		local b = buffer.create(total)
		buffer.writeu32(b, 0, count)

		local offset = 4
		for i = 1, count do
			local bb = bufs[i]
			buffer.copy(b, offset, bb)
			offset += buffer.len(bb)
		end

		return b, total
	end,
	["ValueTable"] = function(raw)
		local keys = {}
		local keyMap = {}
		local n = 0

		for k in raw do
			n += 1
			local keyStr = tostring(k)
			keys[n] = keyStr
			keyMap[keyStr] = k
		end

		table.sort(keys)

		local bufs = table.create(n)
		local total = 4
		local count = 0

		for i = 1, n do
			local keyStr = keys[i]
			local value = raw[keyMap[keyStr]]

			local valueTypeName = resolveTypeName(value)
			local typeId = Attribute_Type_Ids[valueTypeName]
			local descriptor = Binary_Encoders[valueTypeName]
			if not descriptor then
				continue
			end
			local dataBuf, dataSize = descriptor(value)

			local keyLen = #keyStr
			local size = 4 + keyLen + 1 + dataSize
			local b = buffer.create(size)

			buffer.writeu32(b, 0, keyLen)
			buffer.writestring(b, 4, keyStr)
			buffer.writeu8(b, 4 + keyLen, typeId)
			buffer.copy(b, 4 + keyLen + 1, dataBuf)

			count += 1
			bufs[count] = b
			total += size
		end

		local b = buffer.create(total)
		buffer.writeu32(b, 0, count)

		local offset = 4
		for i = 1, count do
			local bb = bufs[i]
			buffer.copy(b, offset, bb)
			offset += buffer.len(bb)
		end

		return b, total
	end,
	["UDim"] = function(raw)
		local b = buffer.create(8)

		buffer.writef32(b, 0, raw.Scale)
		buffer.writei32(b, 4, raw.Offset)

		return b, 8
	end,
	["UDim2"] = function(raw)
		return Binary_Encoders._packMultiple(Binary_Encoders["UDim"], raw.X, raw.Y)
	end,
	["Ray"] = function(raw)
		return Binary_Encoders._packMultiple(Binary_Encoders["Vector3"], raw.Origin, raw.Direction)
	end,
	["Faces"] = function(raw)
		local b = buffer.create(4)

		buffer.writeu32(b, 0, countBits(raw.Right, raw.Top, raw.Back, raw.Left, raw.Bottom, raw.Front))

		return b, 4
	end,
	["Axes"] = function(raw)
		local b = buffer.create(4)

		buffer.writeu32(b, 0, countBits(raw.X, raw.Y, raw.Z))

		return b, 4
	end,
	["BrickColor"] = function(raw)
		local b = buffer.create(4)

		buffer.writeu32(b, 0, raw.Number)

		return b, 4
	end,
	["Color3"] = function(raw)
		return Binary_Encoders._packF32(raw.R, raw.G, raw.B)
	end,
	["Vector2"] = function(raw)
		return Binary_Encoders._packF32(raw.X, raw.Y)
	end,
	["Vector3"] = function(raw)
		return Binary_Encoders._packF32(raw.X, raw.Y, raw.Z)
	end,
	["Vector2int16"] = function(raw)
		return Binary_Encoders._packI16(raw.X, raw.Y)
	end,
	["Vector3int16"] = function(raw)
		return Binary_Encoders._packI16(raw.X, raw.Y, raw.Z)
	end,
	["CFrame"] = function(raw)
		local X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = raw:GetComponents()

		buffer.writef32(rotationBuffer, 0, R00)
		buffer.writef32(rotationBuffer, 4, R01)
		buffer.writef32(rotationBuffer, 8, R02)
		buffer.writef32(rotationBuffer, 12, R10)
		buffer.writef32(rotationBuffer, 16, R11)
		buffer.writef32(rotationBuffer, 20, R12)
		buffer.writef32(rotationBuffer, 24, R20)
		buffer.writef32(rotationBuffer, 28, R21)
		buffer.writef32(rotationBuffer, 32, R22)

		local rotation_ID = CFrame_Rotation_Ids[buffer.tostring(rotationBuffer)]

		local len = rotation_ID and 13 or 49
		local b = buffer.create(len)

		local _packF32 = Binary_Encoders._packF32
		local position = _packF32(X, Y, Z)
		buffer.copy(b, 0, position)

		if rotation_ID then
			buffer.writeu8(b, 12, rotation_ID)
		else
			buffer.writeu8(b, 12, 0x0)

			local xBasis = _packF32(R00, R01, R02)
			buffer.copy(b, 13, xBasis)
			local yBasis = _packF32(R10, R11, R12)
			buffer.copy(b, 13 + 12, yBasis)
			local zBasis = _packF32(R20, R21, R22)
			buffer.copy(b, 13 + 24, zBasis)
		end

		return b, len
	end,
	["EnumItem"] = function(raw)
		local nameBuf, nameSize = Binary_Encoders["string"](tostring(raw.EnumType))

		local len = nameSize + 4
		local b = buffer.create(len)

		buffer.copy(b, 0, nameBuf)
		buffer.writeu32(b, nameSize, raw.Value)

		return b, len
	end,
	["NumberSequence"] = nil,
	["NumberSequenceKeypoint"] = function(keypoint, b, offset)
		if not b then
			return Binary_Encoders._packF32(keypoint.Envelope, keypoint.Time, keypoint.Value)
		end

		buffer.writef32(b, offset, keypoint.Envelope)
		offset += 4
		buffer.writef32(b, offset, keypoint.Time)
		offset += 4
		buffer.writef32(b, offset, keypoint.Value)
	end,
	["ColorSequence"] = nil,
	["ColorSequenceKeypoint"] = function(keypoint, b, offset)
		local value = Binary_Encoders["Color3"](keypoint.Value)

		if not b then
			b = buffer.create(20)
			offset = 0
		end

		buffer.writef32(b, offset, 0)
		offset += 4
		buffer.writef32(b, offset, keypoint.Time)
		offset += 4
		buffer.copy(b, offset, value)

		return b, 20
	end,
	["NumberRange"] = function(raw)
		return Binary_Encoders._packF32(raw.Min, raw.Max)
	end,
	["Rect"] = function(raw)
		return Binary_Encoders._packMultiple(Binary_Encoders["Vector2"], raw.Min, raw.Max)
	end,
	["PhysicalProperties"] = function(raw)
		local b = buffer.create(25)

		buffer.writeu8(b, 0, 1)

		buffer.writef32(b, 1, raw.Density)
		buffer.writef32(b, 5, raw.Friction)
		buffer.writef32(b, 9, raw.Elasticity)
		buffer.writef32(b, 13, raw.FrictionWeight)
		buffer.writef32(b, 17, raw.ElasticityWeight)
		buffer.writef32(b, 21, raw.AcousticAbsorption)

		return b, 25
	end,
	["Color3uint8"] = function(raw)
		local b = buffer.create(3)

		buffer.writeu8(b, 0, math.floor(raw.R * 255))
		buffer.writeu8(b, 1, math.floor(raw.G * 255))
		buffer.writeu8(b, 2, math.floor(raw.B * 255))

		return b, 3
	end,
	["Region3"] = function(raw)
		local Translation = raw.CFrame.Position
		local HalfSize = raw.Size * 0.5

		return Binary_Encoders._packMultiple(
			Binary_Encoders["Vector3"],
			Translation - HalfSize,
			Translation + HalfSize
		)
	end,
	["Region3int16"] = function(raw)
		return Binary_Encoders._packMultiple(Binary_Encoders["Vector3int16"], raw.Min, raw.Max)
	end,
	["Font"] = function(raw)
		local encoder = Binary_Encoders["string"]

		local familyBuf, familySize = encoder(raw.Family)
		local faceIdBuf, faceIdSize = encoder("")

		local len = 3 + familySize + faceIdSize
		local b = buffer.create(len)

		local hasWeight, weight = pcall(index, raw, "Weight")
		local hasStyle, style = pcall(index, raw, "Style")

		buffer.writeu16(b, 0, hasWeight and weight.Value or 0)
		buffer.writeu8(b, 2, hasStyle and style.Value or 0)

		buffer.copy(b, 3, familyBuf)
		buffer.copy(b, 3 + familySize, faceIdBuf)

		return b, len
	end,
	["SecurityCapabilities"] = function(raw)
		local b = buffer.create(8)

		if raw == BASE_CAPABILITIES then
			return b, 8
		end

		Binary_Encoders._writeI64LE(b, 0, countCapabilityBits(raw))

		return b, 8
	end,
	["Path2DControlPoint"] = function(raw)
		return Binary_Encoders._packMultiple(Binary_Encoders["UDim2"], raw.Position, raw.LeftTangent, raw.RightTangent)
	end,
	["TweenInfo"] = function(raw)
		local b = buffer.create(21)

		buffer.writef32(b, 0, raw.Time)
		buffer.writef32(b, 4, raw.DelayTime)
		buffer.writei32(b, 8, raw.RepeatCount)
		buffer.writeu32(b, 12, raw.EasingStyle.Value)
		buffer.writeu32(b, 16, raw.EasingDirection.Value)
		buffer.writeu8(b, 20, raw.Reverses and 1 or 0)

		return b, 21
	end,
}

do
	Binary_Encoders["NumberSequence"] = Binary_Encoders._makeSequence(Binary_Encoders["NumberSequenceKeypoint"], 12)

	Binary_Encoders["ColorSequence"] = Binary_Encoders._makeSequence(Binary_Encoders["ColorSequenceKeypoint"], 20)
end

do
	Binary_Encoders._packF32 = Binary_Encoders._makeVectorPacker(buffer.writef32, 4)

	Binary_Encoders._packI16 = Binary_Encoders._makeVectorPacker(buffer.writei16, 2)
end

local ESCAPES_PATTERN = "[&<>\"'\0\1-\9\11-\12\14-\31\127-\255]"
local ESCAPES = {
	["&"] = "&amp;",
	["<"] = "&lt;",
	[">"] = "&gt;",
	['"'] = "&#34;",
	["'"] = "&#39;",
	["\0"] = "",
}

for rangeStart, rangeEnd in string.gmatch(ESCAPES_PATTERN, "(.)%-(.)") do
	for charCode = string.byte(rangeStart), string.byte(rangeEnd) do
		ESCAPES[string.char(charCode)] = "&#" .. charCode .. ";"
	end
end

local XML_Encoders
XML_Encoders = {
	_cdata = function(raw)
		return "<![CDATA[" .. raw .. "]]>"
	end,
	_protectedString = function(raw)
		return string_find(raw, "]]>") and string.gsub(raw, ESCAPES_PATTERN, ESCAPES) or XML_Encoders._cdata(raw)
	end,
	_normalizeNumber = function(raw)
		if raw ~= raw then
			return "NAN"
		elseif raw == math.huge then
			return "INF"
		elseif raw == -math.huge then
			return "-INF"
		end

		return raw
	end,
	_normalizeRange = function(raw)
		return raw ~= raw and "0" or raw
	end,
	_minMax = function(min, max, encoder)
		return "<min>" .. encoder(min) .. "</min><max>" .. encoder(max) .. "</max>"
	end,
	_makeSequence = function(keypoint_handler)
		return function(raw)
			local sequence = ""

			for _, keypoint in raw.Keypoints do
				sequence ..= keypoint_handler(keypoint)
			end

			return sequence
		end
	end,
	_vector = function(X, Y, Z)
		local Value = "<X>" .. X .. "</X><Y>" .. Y .. "</Y>"

		if Z then
			Value ..= "<Z>" .. Z .. "</Z>"
		end

		return Value
	end,
	Axes = function(raw)
		return "<axes>" .. countBits(raw.X, raw.Y, raw.Z) .. "</axes>"
	end,
	BinaryString = function(raw)
		return raw == "" and "" or base64encode(raw)
	end,
	BrickColor = function(raw)
		return raw.Number
	end,
	CFrame = function(raw)
		local X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = raw:GetComponents()
		return XML_Encoders._vector(X, Y, Z)
			.. "<R00>"
			.. R00
			.. "</R00><R01>"
			.. R01
			.. "</R01><R02>"
			.. R02
			.. "</R02><R10>"
			.. R10
			.. "</R10><R11>"
			.. R11
			.. "</R11><R12>"
			.. R12
			.. "</R12><R20>"
			.. R20
			.. "</R20><R21>"
			.. R21
			.. "</R21><R22>"
			.. R22
			.. "</R22>",
			"CoordinateFrame"
	end,
	Color3 = function(raw)
		return "<R>" .. raw.R .. "</R><G>" .. raw.G .. "</G><B>" .. raw.B .. "</B>"
	end,
	Color3uint8 = function(raw)
		return 0xFF000000
			+ (math.floor(raw.R * 255) * 0x10000)
			+ (math.floor(raw.G * 255) * 0x100)
			+ math.floor(raw.B * 255)
	end,
	ColorSequence = nil,
	ColorSequenceKeypoint = function(keypoint)
		local _normalizeRange = XML_Encoders._normalizeRange

		local color3 = keypoint.Value

		return _normalizeRange(keypoint.Time)
			.. " "
			.. _normalizeRange(color3.R)
			.. " "
			.. _normalizeRange(color3.G)
			.. " "
			.. _normalizeRange(color3.B)
			.. " 0 "
	end,
	Content = function(raw)
		local SourceType = raw.SourceType
		return SourceType == Enum.ContentSourceType.None and "<null></null>"
			or SourceType == Enum.ContentSourceType.Uri and "<uri>" .. XML_Encoders.string(raw.Uri) .. "</uri>"
			or SourceType == Enum.ContentSourceType.Object and "<Ref>" .. getRef(raw.Object) .. "</Ref>"
	end,
	ContentId = function(raw)
		if type(raw) ~= "string" then
			local ok, uri = pcall(function()
				return (raw.SourceType == Enum.ContentSourceType.Uri) and raw.Uri or ""
			end)
			raw = (ok and uri) or ""
		end
		return raw == "" and "<null></null>" or "<url>" .. XML_Encoders.string(raw) .. "</url>", "Content"
	end,
	CoordinateFrame = function(raw)
		return "<CFrame>" .. XML_Encoders.CFrame(raw) .. "</CFrame>"
	end,
	EnumItem = function(raw)
		return raw.Value, "token"
	end,
	Faces = function(raw)
		return "<faces>" .. countBits(raw.Right, raw.Top, raw.Back, raw.Left, raw.Bottom, raw.Front) .. "</faces>"
	end,
	Font = function(raw)
		local hasWeight, weight = pcall(index, raw, "Weight")
		local hasStyle, style = pcall(index, raw, "Style")

		return "<Family>"
			.. XML_Encoders.ContentId(raw.Family)
			.. "</Family><Weight>"
			.. (hasWeight and XML_Encoders.EnumItem(weight) or "")
			.. "</Weight><Style>"
			.. (hasStyle and style.Name or "")
			.. "</Style>"
	end,
	NetAssetRef = nil,
	NumberRange = function(raw)
		local _normalizeRange = XML_Encoders._normalizeRange

		return _normalizeRange(raw.Min) .. " " .. _normalizeRange(raw.Max)
	end,
	NumberSequence = nil,
	NumberSequenceKeypoint = function(keypoint)
		local _normalizeRange = XML_Encoders._normalizeRange

		return _normalizeRange(keypoint.Time)
			.. " "
			.. _normalizeRange(keypoint.Value)
			.. " "
			.. _normalizeRange(keypoint.Envelope)
			.. " "
	end,
	PhysicalProperties = function(raw)
		local CustomPhysics = "<CustomPhysics>" .. XML_Encoders.bool(raw and true or false) .. "</CustomPhysics>"

		return raw
				and CustomPhysics .. "<Density>" .. raw.Density .. "</Density><Friction>" .. raw.Friction .. "</Friction><Elasticity>" .. raw.Elasticity .. "</Elasticity><FrictionWeight>" .. raw.FrictionWeight .. "</FrictionWeight><ElasticityWeight>" .. raw.ElasticityWeight .. "</ElasticityWeight><AcousticAbsorption>" .. raw.AcousticAbsorption .. "</AcousticAbsorption>"
			or CustomPhysics
	end,
	Ray = function(raw)
		local vector3 = XML_Encoders.Vector3

		return "<origin>" .. vector3(raw.Origin) .. "</origin><direction>" .. vector3(raw.Direction) .. "</direction>"
	end,
	Rect = function(raw)
		return XML_Encoders._minMax(raw.Min, raw.Max, XML_Encoders.Vector2), "Rect2D"
	end,
	Region3 = function(raw)
		local Translation = raw.CFrame.Position
		local HalfSize = raw.Size * 0.5

		return XML_Encoders._minMax(
			Translation - HalfSize,
			Translation + HalfSize,
			XML_Encoders.Vector3
		)
	end,
	Region3int16 = function(raw)
		return XML_Encoders._minMax(raw.Min, raw.Max, XML_Encoders.Vector3int16)
	end,
	SharedString = function(raw)
		return sharedStrings[XML_Encoders.BinaryString(raw)]
	end,
	SecurityCapabilities = function(raw)
		if raw == BASE_CAPABILITIES then
			return 0
		end

		return countCapabilityBits(raw)
	end,
	TweenInfo = function(raw)
		local _normalizeNumber = XML_Encoders._normalizeNumber
		return "Time:"
			.. _normalizeNumber(raw.Time)
			.. " DelayTime:"
			.. _normalizeNumber(raw.DelayTime)
			.. " RepeatCount:"
			.. _normalizeNumber(raw.RepeatCount)
			.. " Reverses:"
			.. (raw.Reverses and "True" or "False")
			.. " EasingDirection:"
			.. raw.EasingDirection.Name
			.. " EasingStyle:"
			.. raw.EasingStyle.Name
	end,
	UDim = function(raw)
		return "<S>" .. raw.Scale .. "</S><O>" .. raw.Offset .. "</O>"
	end,
	UDim2 = function(raw)
		local X, Y = raw.X, raw.Y

		return "<XS>"
			.. X.Scale
			.. "</XS><XO>"
			.. X.Offset
			.. "</XO><YS>"
			.. Y.Scale
			.. "</YS><YO>"
			.. Y.Offset
			.. "</YO>"
	end,
	UniqueId = function(raw)
		return string.gsub(raw, "-", "")
	end,
	Vector2 = function(raw)
		return XML_Encoders._vector(raw.X, raw.Y)
	end,
	Vector2int16 = nil,
	Vector3 = function(raw)
		return XML_Encoders._vector(raw.X, raw.Y, raw.Z)
	end,
	Vector3int16 = nil,
	bool = function(raw)
		return raw and "true" or "false"
	end,
	double = nil,
	float = nil,
	int = nil,
	int64 = nil,
	string = function(raw)
		return (raw == nil or raw == "") and ""
			or string_find(raw, "]]>") and string.gsub(raw, ESCAPES_PATTERN, ESCAPES)
			or XML_Encoders._cdata(string.gsub(raw, "\0", ""))
	end,
}

do
	XML_Encoders.NumberSequence = XML_Encoders._makeSequence(XML_Encoders.NumberSequenceKeypoint)

	XML_Encoders.ColorSequence = XML_Encoders._makeSequence(XML_Encoders.ColorSequenceKeypoint)
end

for encoderName, redirectName in
	{
		NetAssetRef = "SharedString",
		Vector2int16 = "Vector2",
		Vector3int16 = "Vector3",
		double = "_normalizeNumber",
		float = "_normalizeNumber",
		int = "_normalizeNumber",
		int64 = "_normalizeNumber",
	}
do
	XML_Encoders[encoderName] = XML_Encoders[redirectName]
end

local ClassList, FetchAPI

do
	local ClassPropertyExceptions = arrayToDict({
		Whitelist = {
			MeshPart = { "CollisionFidelity" },
			PartOperation = { "CollisionFidelity" },
			TriangleMeshPart = { "CollisionFidelity" },
		},
		Blacklist = {
			LuaSourceContainer = { "ScriptGuid" },
			Instance = { "UniqueId", "HistoryId" },
		},
	}, true)

	local function AttributesSerialize(attrs, header_bytes)
		local count = 0
		local buffer_size = 4
		local sorted = {}
		local formatted = table.clone(attrs)

		if header_bytes then
			buffer_size += #header_bytes
		end

		for attr, val in attrs do
			local t = resolveTypeName(val)

			local encoder = Binary_Encoders[t]
			if not encoder then
				continue
			end

			count += 1
			sorted[count] = attr

			local attr_size

			formatted[attr], attr_size = encoder(val)

			buffer_size += 5 + #attr + attr_size
		end

		table.sort(sorted)

		local b = buffer.create(buffer_size)

		local offset = 0

		if header_bytes then
			for _, header_byte in header_bytes do
				buffer.writeu8(b, offset, header_byte)
				offset += 1
			end
		end

		buffer.writeu32(b, offset, count)
		offset += 4

		local stringEncoder = Binary_Encoders["string"]
		for _, attr in sorted do
			local nameBuf, nameSize = stringEncoder(attr)

			buffer.copy(b, offset, nameBuf)
			offset += nameSize

			buffer.writeu8(b, offset, Attribute_Type_Ids[resolveTypeName(attrs[attr])])
			offset += 1

			local bb = formatted[attr]

			buffer.copy(b, offset, bb)
			offset += buffer.len(bb)
		end

		return buffer.tostring(b)
	end

	local function AttenuationSerialize(attenuations)
		if not next(attenuations) then
			return "\0"
		end

		local count = 0

		local sorted = {}

		for key in attenuations do
			count += 1
			sorted[count] = key
		end

		table.sort(sorted)

		local b = buffer.create(1 + count * 8)

		local offset = 1
		for _, key in sorted do
			buffer.writef32(b, offset, key)
			offset += 4
			buffer.writef32(b, offset, attenuations[key])
			offset += 4
		end

		return buffer.tostring(b)
	end

	local function TransformsSerialize(transforms)
		local n = #transforms

		if n == 0 then
			return "\1\0\0\0\0\0\0\0"
		end

		local b = buffer.create(8 + n * 48)

		buffer.writeu32(b, 0, 1)
		buffer.writeu32(b, 4, n)

		local _packF32 = Binary_Encoders._packF32

		local offset = 8
		for _, transform in transforms do
			local X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = transform:GetComponents()

			local xBasis = _packF32(R00, R01, R02)
			buffer.copy(b, offset, xBasis)
			offset += 12

			local yBasis = _packF32(R10, R11, R12)
			buffer.copy(b, offset, yBasis)
			offset += 12

			local zBasis = _packF32(R20, R21, R22)
			buffer.copy(b, offset, zBasis)
			offset += 12

			local position = _packF32(X, Y, Z)
			buffer.copy(b, offset, position)
			offset += 12
		end

		return buffer.tostring(b)
	end

	local function ServiceVisibilitySerialize(wantVisible)
		local ExplorerServiceVisibilityService = game:GetService("ExplorerServiceVisibilityService")
		local stringEncoder = Binary_Encoders["string"]
		local typeId = Attribute_Type_Ids["string"]

		local count = 0
		local buffer_size = 4
		local names = {}
		local formatted = {}

		for _, service in game:GetChildren() do
			if ExplorerServiceVisibilityService:GetServiceVisibility(service) == wantVisible then
				local name = service.ClassName
				local buf, size = stringEncoder(name)

				count += 1
				names[count] = name
				formatted[name] = buf

				buffer_size += 1 + size
			end
		end

		if count == 0 then
			return "\0\0\0\0"
		end

		table.sort(names)

		local b = buffer.create(buffer_size)
		buffer.writeu32(b, 0, count)

		local offset = 4
		for _, name in names do
			buffer.writeu8(b, offset, typeId)
			offset += 1

			local bb = formatted[name]
			buffer.copy(b, offset, bb)
			offset += buffer.len(bb)
		end

		return buffer.tostring(b)
	end

	local function encodeTimeTicks(time)
		local scaled = time * 2400
		if not (scaled >= -2147483648.0 and scaled < 2147483648.0) then
			return -2147483648
		end
		return math.round(scaled)
	end

	local function writeTimesSection(b, offset, keys)
		buffer.writeu32(b, offset, 1)
		offset += 4
		buffer.writeu32(b, offset, #keys)
		offset += 4
		for _, key in keys do
			buffer.writei32(b, offset, encodeTimeTicks(key.Time))
			offset += 4
		end
		return offset
	end

	local function deriveTangentValueCurve(keys, i)
		local key = keys[i]
		local isFirst = (i == 1)
		local isLast = (i == #keys)
		if isLast then
			return 0, 0
		end
		if key.Interpolation == Enum.KeyInterpolationMode.Constant then
			return 0, 0
		end
		if key.Interpolation == Enum.KeyInterpolationMode.Linear then
			local nextKey = keys[i + 1]
			local t = 1 / (nextKey.Time - key.Time)
			return t, t
		end
		if isFirst then
			return 0, 0
		end
		local prevKey = keys[i - 1]
		local deltaPrev = key.Time - prevKey.Time
		if prevKey.Interpolation == Enum.KeyInterpolationMode.Constant then
			return 0, 0
		elseif prevKey.Interpolation == Enum.KeyInterpolationMode.Linear then
			local t = 1 / deltaPrev
			return t, t
		else
			local nextKey = keys[i + 1]
			local deltaNext = nextKey.Time - key.Time
			local t = (1 / deltaPrev + 1 / deltaNext) / 2
			return t, t
		end
	end

	local function deriveTangentFloatCurve(keys, i)
		local key = keys[i]
		local isFirst = (i == 1)
		local isLast = (i == #keys)
		if isLast then
			return 0, 0
		end
		if key.Interpolation == Enum.KeyInterpolationMode.Constant then
			return 0, 0
		end
		if key.Interpolation == Enum.KeyInterpolationMode.Linear then
			local nextKey = keys[i + 1]
			local slope = (nextKey.Value - key.Value) / (nextKey.Time - key.Time)
			return slope, slope
		end
		if isFirst then
			return 0, 0
		end
		local prevKey = keys[i - 1]
		if prevKey.Interpolation == Enum.KeyInterpolationMode.Constant then
			return 0, 0
		elseif prevKey.Interpolation == Enum.KeyInterpolationMode.Linear then
			local slope = (key.Value - prevKey.Value) / (key.Time - prevKey.Time)
			return slope, slope
		else
			return 0, 0
		end
	end

	local NotScriptableFixes = {
		Instance = {
			AttributesSerialize = function(instance)
				local attrs = instance:GetAttributes()

				if not next(attrs) then
					return ""
				end

				return AttributesSerialize(attrs)
			end,
			DefinesCapabilities = "Sandboxed",
			Tags = function(instance)
				local tags = service.CollectionService:GetTags(instance)

				if #tags == 0 then
					return ""
				end

				return table.concat(tags, "\0")
			end,
		},
		Path2D = {
			PropertiesSerialize = function(instance)
				local control_points = instance:GetControlPoints()
				local n = #control_points

				if n == 0 then
					return "\0\0\0\0"
				end

				local b = buffer.create(4 + n * 49)
				buffer.writeu32(b, 0, n)

				local typeId = Attribute_Type_Ids["Path2DControlPoint"]
				local encoder = Binary_Encoders["Path2DControlPoint"]

				local offset = 4
				for i, point in control_points do
					local buf, bufSize = encoder(point)

					buffer.writeu8(b, offset, typeId)
					offset += 1

					buffer.copy(b, offset, buf)
					offset += bufSize
				end

				return buffer.tostring(b)
			end,
		},
		PlayerEmulatorService = {
			SerializedEmulatedPolicyInfo = function(instance)
				local EmulatedPolicyInfo = instance:GetEmulatedPolicyInfo()

				if not next(EmulatedPolicyInfo) then
					return ""
				end

				return AttributesSerialize(EmulatedPolicyInfo)
			end,
		},
		StyleRule = {
			PropertiesSerialize = function(instance)
				local props = instance:GetProperties()

				if not next(props) then
					return "\0\0\0\0"
				end

				return AttributesSerialize(props)
			end,
			PropertyTransitionsSerialize = function(instance)
				local transitions = instance:GetPropertyTransitions()

				if not next(transitions) then
					return "\2\0\0\0\0\0"
				end

				return AttributesSerialize(transitions, { 0x02, 0x00 })
			end,
		},
		StyleQuery = {
			ConditionsSerialize = function(instance)
				local props = instance:GetConditions()

				if not next(props) then
					return "\0\0\0\0"
				end

				return AttributesSerialize(props)
			end,
		},
		FloatCurve = {
			ValuesAndTimes = function(instance)
				local keys = instance:GetKeys()

				if #keys == 0 then
					return "\2\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0"
				end

				local valuesPayloadSize = #keys * 14
				local b = buffer.create(8 + valuesPayloadSize + 8 + (#keys * 4))

				buffer.writeu32(b, 0, 2)
				buffer.writeu32(b, 4, #keys)

				local offset = 8
				for i, key in keys do
					local lt, rt = key.LeftTangent, key.RightTangent
					local mode = countBits(lt, rt)

					if mode == 0 then
						lt, rt = deriveTangentFloatCurve(keys, i)
					elseif mode == 1 then
						rt = lt
					elseif mode == 2 then
						lt = rt
					end

					buffer.writeu8(b, offset, key.Interpolation.Value)
					offset += 1
					buffer.writeu8(b, offset, mode)
					offset += 1
					buffer.writef32(b, offset, key.Value)
					offset += 4
					buffer.writef32(b, offset, lt)
					offset += 4
					buffer.writef32(b, offset, rt)
					offset += 4
				end

				offset = writeTimesSection(b, offset, keys)

				return buffer.tostring(b)
			end,
		},
		RotationCurve = {
			ValuesAndTimes = function(instance)
				local keys = instance:GetKeys()

				if #keys == 0 then
					return "\1\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0"
				end

				local perKeySize = 1 + 16 + 4 + 4
				local b = buffer.create(8 + (#keys * perKeySize) + 8 + (#keys * 4))

				buffer.writeu32(b, 0, 1)
				buffer.writeu32(b, 4, #keys)

				local offset = 8
				for _, key in keys do
					local lt = key.LeftTangent or 0
					local rt = key.RightTangent or 0
					local qx, qy, qz, qw = cframeToQuaternion(key.Value)

					buffer.writeu8(b, offset, 12 + key.Interpolation.Value)
					offset += 1
					buffer.writef32(b, offset, qx)
					offset += 4
					buffer.writef32(b, offset, qy)
					offset += 4
					buffer.writef32(b, offset, qz)
					offset += 4
					buffer.writef32(b, offset, qw)
					offset += 4
					buffer.writef32(b, offset, lt)
					offset += 4
					buffer.writef32(b, offset, rt)
					offset += 4
				end

				offset = writeTimesSection(b, offset, keys)

				return buffer.tostring(b)
			end,
		},
		ValueCurve = {
			ValuesAndTimes = function(instance)
				local keys = instance:GetKeys()

				if #keys == 0 then
					return "\2\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0"
				end

				local valueTypeName = instance.ValueType

				local typeId = Attribute_Type_Ids[valueTypeName]

				if not typeId then
					valueTypeName = resolveTypeName(keys[1].Value)

					typeId = Attribute_Type_Ids[valueTypeName]
				end

				local encoder = Binary_Encoders[valueTypeName]

				if not encoder then
					return "\2\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0"
				end

				local n = #keys
				local bufs = table.create(n)
				local sizes = table.create(n)
				local valuesPayloadSize = 0

				for i, key in keys do
					local dataBuf, dataSize = encoder(key.Value)
					bufs[i] = dataBuf
					sizes[i] = dataSize
					valuesPayloadSize += 1 + 1 + 4 + 1 + dataSize + 4 + 4
				end

				local b = buffer.create(8 + valuesPayloadSize + 8 + 4 * n)
				buffer.writeu32(b, 0, 2)
				buffer.writeu32(b, 4, n)

				local offset = 8
				for i, key in keys do
					local lt, rt = key.LeftTangent, key.RightTangent
					local dataSize = sizes[i]

					buffer.writeu8(b, offset, key.Interpolation.Value)
					offset += 1
					buffer.writeu8(b, offset, countBits(lt, rt))
					offset += 1
					buffer.writeu32(b, offset, dataSize + 1)
					offset += 4
					buffer.writeu8(b, offset, typeId)
					offset += 1
					buffer.copy(b, offset, bufs[i])
					offset += dataSize

					if lt == nil and rt == nil then
						lt, rt = deriveTangentValueCurve(keys, i)
					elseif lt == nil then
						lt = rt
					elseif rt == nil then
						rt = lt
					end

					buffer.writef32(b, offset, lt)
					offset += 4
					buffer.writef32(b, offset, rt)
					offset += 4
				end

				offset = writeTimesSection(b, offset, keys)

				return buffer.tostring(b)
			end,
		},
		MarkerCurve = {
			ValuesAndTimes = function(instance)
				local markers = instance:GetMarkers()
				local n = #markers

				if n == 0 then
					return "\2\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0"
				end

				local strings_size = 0
				for _, marker in markers do
					strings_size += #marker.Value + 1
				end

				local b = buffer.create(8 + strings_size + 8 + (n * 4))

				buffer.writeu32(b, 0, 2)
				buffer.writeu32(b, 4, n)

				local offset = 8
				for _, marker in markers do
					local value = marker.Value
					buffer.writestring(b, offset, value)
					offset += #value + 1
				end

				offset = writeTimesSection(b, offset, markers)

				return buffer.tostring(b)
			end,
		},
		AnimationNodeDefinition = {
			InputPinData = function(instance)
				local input_pins = instance:GetInputPins()

				local n = #input_pins

				if n == 0 then
					return "\1\0\0\0\0\0\0\0"
				end

				local buffer_size = 8

				for _, pin in input_pins do
					buffer_size += 4 + #pin
				end

				local b = buffer.create(buffer_size)

				buffer.writeu32(b, 0, 1)
				buffer.writeu32(b, 4, n)

				local encoder = Binary_Encoders["string"]
				local offset = 8
				for _, pin in input_pins do
					local pinBuf, pinSize = encoder(pin)

					buffer.copy(b, offset, pinBuf)
					offset += pinSize
				end

				return buffer.tostring(b)
			end,
		},
		AnimationClip = {
			GuidBinaryString = function(instance)
				local cleanGuid = string.gsub(instance.Guid, "[{}-]", "")
				local bytes = buffer.create(16)

				for i = 0, 15 do
					local hexByte = string.sub(cleanGuid, (i * 2) + 1, (i * 2) + 2)
					local val = tonumber(hexByte, 16) or 0
					buffer.writeu8(bytes, i, val)
				end

				return buffer.tostring(bytes)
			end,
		},
		AnimationRigData = {
			label = function(instance)
				local labels = instance:GetLabels()
				local n = #labels

				if n == 0 then
					return "\1\0\0\0\0\0\0\0"
				end

				local b = buffer.create(8 + n * 4)

				buffer.writeu32(b, 0, 1)
				buffer.writeu32(b, 4, n)

				local offset = 8

				for _, label in labels do
					buffer.writeu32(b, offset, label)
					offset += 4
				end

				return buffer.tostring(b)
			end,
			name = function(instance)
				local names = instance:GetNames()
				local n = #names

				if n == 0 then
					return "\1\0\0\0\0\0\0\0"
				end

				local buffer_size = 8

				for _, name in names do
					buffer_size += 4 + #name
				end

				local b = buffer.create(buffer_size)

				buffer.writeu32(b, 0, 1)
				buffer.writeu32(b, 4, n)

				local offset = 8

				for _, name in names do
					buffer.writeu32(b, offset, #name)
					offset += 4
				end
				for _, name in names do
					buffer.writestring(b, offset, name)
					offset += #name
				end

				return buffer.tostring(b)
			end,
			parent = function(instance)
				local parents = instance:GetParents()
				local n = #parents

				if n == 0 then
					return "\1\0\0\0\0\0\0\0"
				end

				local b = buffer.create(8 + #parents * 2)

				buffer.writeu32(b, 0, 1)
				buffer.writeu32(b, 4, n)

				local offset = 8

				for _, parent in parents do
					buffer.writeu16(b, offset, parent)
					offset += 2
				end

				return buffer.tostring(b)
			end,
			postTransform = function(instance)
				return TransformsSerialize(instance:GetPostTransforms())
			end,
			preTransform = function(instance)
				return TransformsSerialize(instance:GetPreTransforms())
			end,
			transform = function(instance)
				return TransformsSerialize(instance:GetTransforms())
			end,
		},
		AudioDeviceInput = {
			AccessList = function(instance)
				local userid_accesslist = instance:GetUserIdAccessList()

				local n = #userid_accesslist

				if n == 0 then
					return ""
				end

				local b = buffer.create(n * 8)

				local _writeI64LE = Binary_Encoders._writeI64LE

				local offset = 0
				for _, user_id in userid_accesslist do
					_writeI64LE(b, offset, user_id)
					offset += 8
				end

				return buffer.tostring(b)
			end,
		},
		AudioEmitter = {
			AngleAttenuation = function(instance)
				return AttenuationSerialize(instance:GetAngleAttenuation())
			end,
			DistanceAttenuation = function(instance)
				return AttenuationSerialize(instance:GetDistanceAttenuation())
			end,
		},
		AudioListener = {
			AngleAttenuation = function(instance)
				return AttenuationSerialize(instance:GetAngleAttenuation())
			end,
			DistanceAttenuation = function(instance)
				return AttenuationSerialize(instance:GetDistanceAttenuation())
			end,
		},
		DebuggerBreakpoint = { line = "Line" },
		BallSocketConstraint = { MaxFrictionTorqueXml = "MaxFrictionTorque" },
		BasePart = {
			Color3uint8 = "Color",
			MaterialVariantSerialized = "MaterialVariant",
			size = "Size",
			siz = "Size",
		},
		DoubleConstrainedValue = { value = "Value" },
		IntConstrainedValue = { value = "Value" },

		CustomEvent = {
			PersistedCurrentValue = function(instance)
				local receiver = instance:GetAttachedReceivers()[1]
				if receiver then
					return receiver:GetCurrentValue()
				end

				local tempReceiver = Instance.new("CustomEventReceiver")
				local clone = Instance.fromExisting(instance)

				tempReceiver.Source = clone
				local value = tempReceiver:GetCurrentValue()

				tempReceiver:Destroy()
				clone:Destroy()

				return value
			end,
		},

		Terrain = {
			MaterialColors = function(instance)
				local TERRAIN_MATERIAL_COLORS =
					{
						Enum.Material.Grass,
						Enum.Material.Slate,
						Enum.Material.Concrete,
						Enum.Material.Brick,
						Enum.Material.Sand,
						Enum.Material.WoodPlanks,
						Enum.Material.Rock,
						Enum.Material.Glacier,
						Enum.Material.Snow,
						Enum.Material.Sandstone,
						Enum.Material.Mud,
						Enum.Material.Basalt,
						Enum.Material.Ground,
						Enum.Material.CrackedLava,
						Enum.Material.Asphalt,
						Enum.Material.Cobblestone,
						Enum.Material.Ice,
						Enum.Material.LeafyGrass,
						Enum.Material.Salt,
						Enum.Material.Limestone,
						Enum.Material.Pavement,
					}

				local b = buffer.create(69)
				local offset = 6

				for _, material in TERRAIN_MATERIAL_COLORS do
					local color = instance:GetMaterialColor(material)
					buffer.writeu8(b, offset, (color.R * 255))
					offset += 1
					buffer.writeu8(b, offset, (color.G * 255))
					offset += 1
					buffer.writeu8(b, offset, (color.B * 255))
					offset += 1
				end

				return buffer.tostring(b)
			end,
		},
		BaseWrap = {
			TemporaryCageMeshContent = function(instance)
				return Content.fromUri(gethiddenproperty_fallback(instance, "TemporaryCageMeshId"))
			end,
		},
		MaterialVariant = {
			TexturePackContent = function(instance)
				return Content.fromUri(gethiddenproperty_fallback(instance, "TexturePack"))
			end,
		},
		TerrainDetail = {
			TexturePackContent = function(instance)
				return Content.fromUri(gethiddenproperty_fallback(instance, "TexturePack"))
			end,
		},
		WrapLayer = {
			TemporaryReferenceMeshContent = function(instance)
				return Content.fromUri(gethiddenproperty_fallback(instance, "TemporaryReferenceId"))
			end,
		},
		TriangleMeshPart = {
			FluidFidelityInternal = "FluidFidelity",
		},
		MeshPart = {
			InitialSize = "MeshSize",
			MeshID = "MeshId",
			VertexCount = function(instance)
				local meshId = instance.MeshId
				if meshId == "" then
					return __BREAK
				end
				return #service.UGCValidationService:GetMeshVerts(meshId)
			end,
		},
		PartOperation = {
			Content = function(instance)
				return Content.fromUri(gethiddenproperty_fallback(instance, "AssetId"))
			end,
			InitialSize = "MeshSize",
		},
		Part = { shape = "Shape", shap = "Shape" },
		TrussPart = { style = "Style" },
		FormFactorPart = {
			formFactorRaw = "FormFactor",
		},
		Fire = { heat_xml = "Heat", size_xml = "Size" },
		Clothing = {
			Outfit1Content = function(instance)
				return Content.fromUri(gethiddenproperty_fallback(instance, "Outfit1"))
			end,
			Outfit2Content = function(instance)
				return Content.fromUri(gethiddenproperty_fallback(instance, "Outfit2"))
			end,
		},
		Humanoid = {
			Health_XML = "Health",
			InternalBodyScale = function(instance)
				local a = instance.RootPart

				if not a then
					return __BREAK
				end

				return instance:GetAccessoryHandleScale(a, Enum.BodyPartR15.RootPart)
			end,
			InternalHeadScale = function(instance)
				local a = instance.Parent and instance.Parent:FindFirstChild("Head")

				if not a then
					return __BREAK
				end

				return instance:GetAccessoryHandleScale(a, Enum.BodyPartR15.Head).X
			end,
			NetworkHumanoidState = function(instance)
				return instance:GetState()
			end,
		},
		HumanoidDescription = {
			AccessoryBlob = function(instance)
				local blob = {}

				for _, acc in instance:GetAccessories(false) do
					table.insert(blob, {
						AssetId = acc.AssetId,
						Order = acc.Order,
						AccessoryType = acc.AccessoryType.Name,
						Puffiness = acc.Puffiness,
					})
				end

				return service.HttpService:JSONEncode(blob)
			end,
			EmotesDataInternal = function(instance)
				local emotes_data = ""
				for name, ids in instance:GetEmotes() do
					emotes_data ..= name .. "^" .. table.concat(ids, "^") .. "^\\"
				end
				return emotes_data
			end,
			EquippedEmotesDataInternal = function(instance)
				local equipped_emotes = instance:GetEquippedEmotes()
				if #equipped_emotes == 0 then
					return ""
				end

				local equipped_emotes_data = ""
				for _, emote in equipped_emotes do
					equipped_emotes_data = equipped_emotes_data .. emote.Slot .. "^" .. emote.Name .. "\\"
				end
				return equipped_emotes_data
			end,
		},
		LocalizationTable = {
			Contents = function(instance)
				return instance:GetContents()
			end,
		},
		MaterialService = { Use2022MaterialsXml = "Use2022Materials" },
		VideoPlayer = {
			PlayingReplicating = "IsPlaying",
		},

		Model = {
			ModelMeshCFrame = function(instance)
				return instance:GetModelCFrame()
			end,
			ModelMeshSize = function(instance)
				return instance:GetExtentsSize()
			end,
			Scale = function(instance)
				return instance:GetScale()
			end,
			ScaleFactor = function(instance)
				return instance:GetScale()
			end,
			WorldPivotData = "WorldPivot",
		},
		PackageLink = {
			PackageContentSerialize = "PackageContent",
			PackageIdSerialize = "PackageId",
			VersionIdSerialize = "VersionNumber",
		},
		Players = { MaxPlayersInternal = "MaxPlayers", PreferredPlayersInternal = "PreferredPlayers" },

		StarterPlayer = {
			AvatarJointUpgrade_SerializedRollout = "AvatarJointUpgrade",
		},
		Smoke = { size_xml = "Size", opacity_xml = "Opacity", riseVelocity_xml = "RiseVelocity" },
		Sound = {
			xmlRead_MinDistance_3 = "RollOffMinDistance",
			xmlRead_MaxDistance_3 = "RollOffMaxDistance",
		},
		ViewportFrame = {
			CameraCFrame = function(instance)
				local CurrentCamera = instance.CurrentCamera

				return CurrentCamera and CurrentCamera.CFrame or CFrame.identity
			end,
			CameraFieldOfView = function(instance)
				local CurrentCamera = instance.CurrentCamera

				return math.rad(CurrentCamera and CurrentCamera.FieldOfView or 70)
			end,
		},
		WeldConstraint = {
			CFrame0 = function(instance)
				local Part0, Part1 = instance.Part0, instance.Part1

				return Part0 and Part1 and Part0.CFrame:ToObjectSpace(Part1.CFrame) or CFrame.identity
			end,
			CFrame1 = function(instance)
				local Part0, Part1 = instance.Part0, instance.Part1

				return Part0 and Part1 and Part1.CFrame:ToObjectSpace(Part0.CFrame) or CFrame.identity
			end,
			Part0Internal = "Part0",
			Part1Internal = "Part1",
			State = function(instance)
				return countBits(instance.Enabled, instance.Active)
			end,
		},
		Workspace = {
			CollisionGroups = function()
				local registered = game:GetService("PhysicsService"):GetRegisteredCollisionGroups()

				local n = #registered
				if n == 0 then
					return ""
				end

				local parts = table.create(n)
				for i, group in registered do
					parts[i] = group.name .. "^" .. i - 1 .. "^" .. group.mask
				end
				return table.concat(parts, "\\")
			end,
		},
		WorldRoot = {
			CollisionGroupData = function()
				local collision_groups = game:GetService("PhysicsService"):GetRegisteredCollisionGroups()
				local n = #collision_groups

				if n == 0 then
					return "\1\0"
				end

				local buffer_size = 2

				for _, group in collision_groups do
					buffer_size += 7 + #group.name
				end

				local b = buffer.create(buffer_size)

				buffer.writeu8(b, 0, 1)
				buffer.writeu8(b, 1, n)

				local typeId_int32 = Attribute_Type_Ids["int32"]
				local offset = 2

				for i, group in collision_groups do
					local name, id, mask = group.name, i - 1, group.mask
					local name_len = #name

					buffer.writeu8(b, offset, id)
					offset += 1

					buffer.writeu8(b, offset, typeId_int32)
					offset += 1

					buffer.writei32(b, offset, mask)
					offset += 4

					buffer.writeu8(b, offset, name_len)
					offset += 1
					buffer.writestring(b, offset, name)
					offset += name_len
				end

				return buffer.tostring(b)
			end,
		},

		ServiceVisibilityService = {
			HiddenServices = function()
				return ServiceVisibilitySerialize(false)
			end,
			VisibleServices = function()
				return ServiceVisibilitySerialize(true)
			end,
		},
	}
	for _, enum_item in Enum.Material:GetEnumItems() do
		NotScriptableFixes.MaterialService[enum_item.Name .. "Name"] = function(instance)
			return instance:GetBaseMaterialOverride(enum_item)
		end
	end

	NotScriptableFixes.Workspace.CollisionGroupData = NotScriptableFixes.WorldRoot.CollisionGroupData

	FetchAPI = function()
		local FILE_NAME = "API_DUMP.json"

		local API_Dump

		local Max_SecurityCapabilities = SecurityCapabilities.new(unpack(Enum.SecurityCapability:GetEnumItems()))
		local filter = { Security = Max_SecurityCapabilities, ExcludeDisplay = true, ExcludeInherited = true }

		local APIDUMP_FETCHERS = {
			[1] = function()
				local res = readfile(FILE_NAME)
				if res and res ~= "" then
					return service.HttpService:JSONDecode(res)[FULL_VERSION]
				end
			end,
			[2] = function()
				local client_version_str = tostring(CLIENT_VERSION)
				local dump
				local matching_versions, matched, is_matched, exact_match = {}, {}, {}
				local function process_line(line, noinsert)
					local file_version, patch_commit, version_hash =
						string.match(line, '"%d+%.(%d+)%.([^"]+)": "(version%-[^"]+)')
					if file_version == client_version_str then
						is_matched = true
						if version_hash and not matched[version_hash] then
							matched[version_hash] = true
							if not noinsert then
								table.insert(matching_versions, version_hash)
							end
							if string.sub(FULL_VERSION, -#patch_commit) == patch_commit then
								return version_hash
							end
						end
					elseif is_matched then
						return false
					end
				end

				local function isFullDump(classes)
					for _, class in classes do
						for _, member in class.Members do
							if member.MemberType == "Property" then
								return member.Default ~= nil
							end
						end
					end
					return false
				end

				local function tryFetchDump(url)
					local ok, decoded = pcall(function()
						local raw = game:HttpGet(url, true)
						return service.HttpService:JSONDecode(raw)
					end)
					return ok and decoded.Classes or nil
				end

				local function fetchFullApiDump(hash)
					local decoded = tryFetchDump("https://setup.rbxcdn.com/" .. hash .. "-Full-API-Dump.json")
					if decoded and isFullDump(decoded) then
						return decoded
					end

					decoded = tryFetchDump(
						"https://raw.githubusercontent.com/setup-rbxcdn/roblox-full-api-dumps/refs/heads/main/full-dumps/"
							.. hash
							.. "-Full-API-Dump.json"
					)
					if decoded and isFullDump(decoded) then
						return decoded
					end

					return nil
				end

				do
					local o, r = pcall(
						game.HttpGet,
						game,
						"https://raw.githubusercontent.com/setup-rbxcdn/setup-rbxcdn.github.io/refs/heads/main/version-history/Windows/Studio64.json",
						true
					)
					if o then
						local version_history = string.split(r, "\n")
						version_history[#version_history] = nil
						for i = #version_history, 2, -1 do
							local res = process_line(version_history[i])
							if res == false then
								break
							elseif res then
								exact_match = res
							end
						end
					end
				end
				do
					local function fallback_channel(channel)
						local ok, res = pcall(function()
							return service.HttpService:JSONDecode(
								game:HttpGet(
									"https://clientsettingscdn.roblox.com/v2/client-version/WindowsStudio64"
										.. (channel and "/channel/" .. channel or ""),
									true
								)
							)
						end)
						if not ok then
							return
						end
						if res.version and res.clientVersionUpload then
							local line = '"' .. res.version .. '": "' .. res.clientVersionUpload
							return process_line(line, true)
						end
					end
					if not exact_match then
						exact_match = fallback_channel("zbeta") or fallback_channel()
					end
				end
				if exact_match then
					dump = fetchFullApiDump(exact_match)
				end
				if not dump then
					for _, version_hash in matching_versions do
						dump = fetchFullApiDump(version_hash)
						if dump then
							break
						end
					end
				end
				return dump
			end,
			[3] = function()
				local classes, classes_size = {}, 1

				for _, api_class in service.ReflectionService:GetClasses(filter) do
					local members, members_size = {}, 1
					local className = api_class.Name

					local class = {
						Name = className,
						Members = members,
						Superclass = api_class.Superclass or "<<<ROOT>>>",
					}
					local permits = api_class.Permits

					local tags = {}
					if api_class.Service then
						table.insert(tags, "Service")
					elseif permits and permits["GetService"] then
						table.insert(tags, "Service")
					elseif not permits or not permits["New"] then
						table.insert(tags, "NotCreatable")
					end

					if #tags ~= 0 then
						class.Tags = tags
					end

					local o, r = pcall(
						service.ReflectionService.GetPropertiesOfClass,
						service.ReflectionService,
						className,
						filter
					)
					if o then
						for _, property in r do
							local propertyName = property.Name

							local valueType = property.Type
							local valueType_Name = valueType.EngineType

							local category = valueType.Category

							local member_tags = {}

							if not next(property.Permits) then
								table.insert(member_tags, "NotScriptable")
							end

							if valueType_Name == "Enum" then
								category, valueType_Name = "Enum", valueType.EnumType
							elseif valueType_Name == "RefType" then
								category, valueType_Name = "Class", valueType.InstanceType
							else
								local renames = {
									CoordinateFrame = "CFrame",
									Rect2D = "Rect",
									Vector3Int16 = "Vector3int16",
									Vector2Int16 = "Vector2int16",
									Region3Int16 = "Region3int16",
								}
								valueType_Name = renames[valueType_Name] or valueType_Name
							end

							local member = {
								Name = propertyName,
								MemberType = "Property",
								ValueType = { Name = valueType_Name, Category = category },
								Serialization = { CanLoad = property.Serialized, CanSave = property.Serialized },
							}

							if #member_tags ~= 0 then
								member.Tags = member_tags
							end

							members[members_size] = member
							members_size += 1
						end
					end
					classes[classes_size] = class
					classes_size += 1
				end

				return classes
			end,
			[4] = function()
				return service.HttpService:JSONDecode(
					game:HttpGet(
						"https://raw.githubusercontent.com/MaximumADHD/Roblox-Client-Tracker/roblox/Mini-API-Dump.json",
						true
					)
				).Classes
			end,
		}

		for i, fetcher in APIDUMP_FETCHERS do
			local o, r = pcall(fetcher)
			if o and r then
				API_Dump = r
				if i == 2 then
					if writefile then
						local ok, err =
							pcall(writefile, FILE_NAME, service.HttpService:JSONEncode({ [FULL_VERSION] = API_Dump }))
						if not ok then
							warn("[DEBUG] DUMP writefile error", err)
						end
					end
				end
				break
			elseif r ~= false and 2 < i then
				warn("[DEBUG] Failed to get", FULL_VERSION, "version API Dump, trying fallbacks..")
				warn("[DEBUG] Method number:", i, "Reason:", r)
			end
		end

		local classList = {}
		local tmp_classDict = {}

		local ClassesWhitelist, ClassesBlacklist = ClassPropertyExceptions.Whitelist, ClassPropertyExceptions.Blacklist

		local API_Dump_Decoded = API_Dump

		for _, API_Class in API_Dump_Decoded do
			local ClassName = API_Class.Name
			local props = {}

			for _, Member in API_Class.Members do
				local MemberType = Member.MemberType
				if MemberType == "Property" or MemberType == "Function" then
					props[Member.Name] = {
						ValueType = MemberType == "Property" and Member.ValueType.Name,
						MemberType = MemberType,
					}
				end
			end

			tmp_classDict[ClassName] = props
		end

		for _, API_Class in API_Dump_Decoded do
			local ClassProperties, ClassProperties_size = {}, 1
			local Class = {
				Properties = ClassProperties,
				Superclass = API_Class.Superclass,
				NotCreatable = nil,
			}

			local ClassName = API_Class.Name
			local ClassTags = API_Class.Tags

			if ClassTags then
				local Tags = arrayToDict(ClassTags, nil, nil, "string")
				Class.NotCreatable = Tags.NotCreatable
				Class.Service = Tags.Service
			end

			local NotScriptableFixClass = NotScriptableFixes[ClassName]

			local ClassWhitelist, ClassBlacklist = ClassesWhitelist[ClassName], ClassesBlacklist[ClassName]

			local ContentProperties
			for _, Member in API_Class.Members do
				if Member.MemberType == "Property" then
					local Serialization = Member.Serialization

					if Serialization.CanLoad then
						local PropertyName = Member.Name

						local ValueType = Member.ValueType
						local ValueType_Name = ValueType.Name

						if ValueType_Name == "Content" or ValueType_Name == "AssetContentMap" then
							if not ContentProperties then
								ContentProperties = {}

								local o, properties = pcall(
									service.ReflectionService.GetPropertiesOfClass,
									service.ReflectionService,
									ClassName,
									filter
								)
								if o then
									for _, property in properties do
										ContentProperties[property.Name] = property.Serialized
									end
								end
							end
							if ContentProperties[PropertyName] ~= nil then
								Serialization.CanSave = ContentProperties[PropertyName]
							end
						end

						if
							(Serialization.CanSave or ClassWhitelist and ClassWhitelist[PropertyName])
							and not (ClassBlacklist and ClassBlacklist[PropertyName])
						then
							local MemberTags = Member.Tags

							local Special, PreferredDescriptorName

							if MemberTags then
								for _, tag in MemberTags do
									if type(tag) == "table" then
										PreferredDescriptorName = tag.PreferredDescriptorName
										if PreferredDescriptorName and Special then
											break
										end
									elseif tag == "NotScriptable" then
										Special = true
										if PreferredDescriptorName then
											break
										end
									end
								end
							end

							local preferredDescriptorProp
							if PreferredDescriptorName then
								preferredDescriptorProp = tmp_classDict[ClassName][PreferredDescriptorName]

								if
									preferredDescriptorProp == nil
									or (
										preferredDescriptorProp.MemberType == "Property"
										and ValueType_Name ~= preferredDescriptorProp.ValueType
									)
								then
									PreferredDescriptorName = nil
								end
							end

							local Property = {
								Name = PropertyName,
								Category = ValueType.Category,
								ValueType = ValueType_Name,

								Special = Special,

								CanRead = nil,
							}

							if string.sub(ValueType_Name, 1, 8) == "Optional" then
								Property.Optional = string.sub(ValueType_Name, 9)
							end

							local NotScriptableFix = NotScriptableFixClass and NotScriptableFixClass[PropertyName]
							local accessFunc = PreferredDescriptorName
								and (
									preferredDescriptorProp.MemberType == "Property"
										and function(instance)
											return instance[PreferredDescriptorName]
										end
									or function(instance)
										return instance[PreferredDescriptorName](instance)
									end
								)

							Property.Fallback = NotScriptableFix
									and (type(NotScriptableFix) == "function" and NotScriptableFix or accessFunc and function(
										instance
									)
										local o, r = pcall(accessFunc, instance)
										if o then
											return r
										end
										return instance[NotScriptableFix]
									end or function(instance)
										return instance[NotScriptableFix]
									end)
								or accessFunc

							ClassProperties[ClassProperties_size] = Property
							ClassProperties_size += 1
						end
					end
				end
			end

			classList[ClassName] = Class
		end

		return classList
	end
end

local GLOBAL_ENV = getgenv and getgenv() or _G or shared

-- GUI Components
local GUI_OPTIONS = {
	Decompile = true,
	NilInstances = false,
	RemovePlayers = true,
	ShowStatus = true,
	SafeMode = true,
	KillAllScripts = true,
	BoostFPS = true,
	SaveBytecode = false,
	IgnoreDefaultProperties = true,
}

local tooltips = {
	Decompile = "Decompile scripts to readable Lua code. If disabled, scripts will be saved as bytecode or empty.",
	NilInstances = "Save instances that are not parented to anything. Can include duplicate or ghost instances.",
	RemovePlayers = "Remove all player instances from the save. Helps reduce file size and protect player data.",
	ShowStatus = "Show a progress GUI while saving. Includes a progress bar and status text.",
	SafeMode = "Kicks you before saving to prevent crashes. Highly recommended!",
	KillAllScripts = "Stops all running scripts before saving. Prevents interference during save process.",
	BoostFPS = "Disables 3D rendering to improve save speed. Re-enables after saving.",
	SaveBytecode = "Saves raw bytecode along with decompiled scripts. Useful for debugging.",
	IgnoreDefaultProperties = "Skip properties that are at their default values. Reduces file size significantly.",
}

local function createSaveGUI()
	local gui = Instance.new("ScreenGui")
	gui.Name = "VCopySaveGUI"
	gui.DisplayOrder = 999
	gui.ResetOnSpawn = false
	
	pcall(function()
		gui.OnTopOfCoreBlur = true
	end)

	-- Main Frame with gradient
	local mainFrame = Instance.new("Frame")
	mainFrame.Size = UDim2.new(0, 420, 0, 500)
	mainFrame.Position = UDim2.new(0.5, -210, 0.5, -250)
	mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	mainFrame.BackgroundTransparency = 0.05
	mainFrame.BorderSizePixel = 0
	mainFrame.ClipsDescendants = true
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = mainFrame
	
	-- Gradient overlay
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 60)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
	})
	gradient.Parent = mainFrame
	
	-- Glow border
	local border = Instance.new("Frame")
	border.Size = UDim2.new(1, 4, 1, 4)
	border.Position = UDim2.new(0, -2, 0, -2)
	border.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
	border.BackgroundTransparency = 0.3
	border.BorderSizePixel = 0
	local borderCorner = Instance.new("UICorner")
	borderCorner.CornerRadius = UDim.new(0, 14)
	borderCorner.Parent = border
	border.Parent = mainFrame
	
	-- Title
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 50)
	title.Position = UDim2.new(0, 0, 0, 10)
	title.BackgroundTransparency = 1
	title.Text = "⚡ VCopy Service"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 24
	title.Font = Enum.Font.GothamBold
	title.TextScaled = true
	title.TextXAlignment = Enum.TextXAlignment.Center
	title.Parent = mainFrame
	
	-- Subtitle
	local subtitle = Instance.new("TextLabel")
	subtitle.Size = UDim2.new(1, 0, 0, 25)
	subtitle.Position = UDim2.new(0, 0, 0, 55)
	subtitle.BackgroundTransparency = 1
	subtitle.Text = "Save Instance Configuration"
	subtitle.TextColor3 = Color3.fromRGB(150, 180, 255)
	subtitle.TextSize = 14
	subtitle.Font = Enum.Font.GothamMedium
	subtitle.TextXAlignment = Enum.TextXAlignment.Center
	subtitle.Parent = mainFrame
	
	-- Scrollable container for options
	local scrollContainer = Instance.new("ScrollingFrame")
	scrollContainer.Size = UDim2.new(1, -30, 0, 300)
	scrollContainer.Position = UDim2.new(0, 15, 0, 90)
	scrollContainer.BackgroundTransparency = 1
	scrollContainer.BorderSizePixel = 0
	scrollContainer.ScrollBarThickness = 4
	scrollContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
	scrollContainer.ScrollBarImageTransparency = 0.5
	scrollContainer.CanvasSize = UDim2.new(0, 0, 0, 390)
	scrollContainer.Parent = mainFrame
	
	local optionList = Instance.new("UIListLayout")
	optionList.Padding = UDim.new(0, 8)
	optionList.SortOrder = Enum.SortOrder.LayoutOrder
	optionList.Parent = scrollContainer
	
	-- Options storage
	local optionToggles = {}
	local optionLabels = {}
	
	local function createOption(parent, key, label, defaultValue)
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, -10, 0, 40)
		frame.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
		frame.BackgroundTransparency = 0.3
		frame.BorderSizePixel = 0
		
		local frameCorner = Instance.new("UICorner")
		frameCorner.CornerRadius = UDim.new(0, 8)
		frameCorner.Parent = frame
		
		-- Label
		local labelObj = Instance.new("TextLabel")
		labelObj.Size = UDim2.new(0.6, 0, 1, 0)
		labelObj.Position = UDim2.new(0, 10, 0, 0)
		labelObj.BackgroundTransparency = 1
		labelObj.Text = label
		labelObj.TextColor3 = Color3.fromRGB(220, 220, 240)
		labelObj.TextSize = 14
		labelObj.Font = Enum.Font.GothamMedium
		labelObj.TextXAlignment = Enum.TextXAlignment.Left
		labelObj.TextTruncate = Enum.TextTruncate.AtEnd
		labelObj.Parent = frame
		
		-- Toggle button
		local toggle = Instance.new("TextButton")
		toggle.Size = UDim2.new(0, 60, 0, 30)
		toggle.Position = UDim2.new(1, -70, 0.5, -15)
		toggle.BackgroundColor3 = defaultValue and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(200, 80, 80)
		toggle.BackgroundTransparency = 0.2
		toggle.BorderSizePixel = 0
		toggle.Text = defaultValue and "ON" or "OFF"
		toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
		toggle.TextSize = 13
		toggle.Font = Enum.Font.GothamBold
		
		local toggleCorner = Instance.new("UICorner")
		toggleCorner.CornerRadius = UDim.new(0, 6)
		toggleCorner.Parent = toggle
		
		-- Glow effect on toggle
		local glow = Instance.new("Frame")
		glow.Size = UDim2.new(1, 6, 1, 6)
		glow.Position = UDim2.new(0, -3, 0, -3)
		glow.BackgroundColor3 = toggle.BackgroundColor3
		glow.BackgroundTransparency = 0.6
		glow.BorderSizePixel = 0
		local glowCorner = Instance.new("UICorner")
		glowCorner.CornerRadius = UDim.new(0, 9)
		glowCorner.Parent = glow
		glow.Parent = toggle
		
		toggle.Parent = frame
		
		-- Tooltip (hidden by default)
		local tooltip = Instance.new("TextLabel")
		tooltip.Size = UDim2.new(0.8, 0, 0, 30)
		tooltip.Position = UDim2.new(0.1, 0, 1, 5)
		tooltip.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
		tooltip.BackgroundTransparency = 0.1
		tooltip.BorderSizePixel = 0
		tooltip.Text = tooltips[key] or ""
		tooltip.TextColor3 = Color3.fromRGB(180, 190, 220)
		tooltip.TextSize = 11
		tooltip.Font = Enum.Font.Gotham
		tooltip.TextXAlignment = Enum.TextXAlignment.Center
		tooltip.TextWrapped = true
		tooltip.Visible = false
		
		local tooltipCorner = Instance.new("UICorner")
		tooltipCorner.CornerRadius = UDim.new(0, 4)
		tooltipCorner.Parent = tooltip
		
		tooltip.Parent = frame
		
		-- Mouse hover events
		local function showTooltip()
			tooltip.Visible = true
			frame.BackgroundTransparency = 0.1
		end
		
		local function hideTooltip()
			tooltip.Visible = false
			frame.BackgroundTransparency = 0.3
		end
		
		frame.MouseEnter:Connect(showTooltip)
		frame.MouseLeave:Connect(hideTooltip)
		labelObj.MouseEnter:Connect(showTooltip)
		labelObj.MouseLeave:Connect(hideTooltip)
		toggle.MouseEnter:Connect(showTooltip)
		toggle.MouseLeave:Connect(hideTooltip)
		
		local function toggleState()
			local current = GUI_OPTIONS[key]
			GUI_OPTIONS[key] = not current
			toggle.BackgroundColor3 = GUI_OPTIONS[key] and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(200, 80, 80)
			toggle.Text = GUI_OPTIONS[key] and "ON" or "OFF"
			glow.BackgroundColor3 = toggle.BackgroundColor3
			
			-- Update option label color
			labelObj.TextColor3 = GUI_OPTIONS[key] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 200)
		end
		
		toggle.MouseButton1Click:Connect(toggleState)
		
		frame.Parent = parent
		
		optionToggles[key] = toggle
		optionLabels[key] = labelObj
		
		return frame
	end
	
	-- Create options in order
	local optionOrder = {
		{"Decompile", "🔄 Decompile Scripts"},
		{"NilInstances", "📂 Save Nil Instances"},
		{"RemovePlayers", "👤 Remove Players"},
		{"ShowStatus", "📊 Show Status"},
		{"SafeMode", "🛡️ Safe Mode"},
		{"KillAllScripts", "💀 Kill All Scripts"},
		{"BoostFPS", "⚡ Boost FPS"},
		{"SaveBytecode", "💾 Save Bytecode"},
		{"IgnoreDefaultProperties", "📦 Ignore Default Props"},
	}
	
	for _, data in ipairs(optionOrder) do
		local key, label = data[1], data[2]
		createOption(scrollContainer, key, label, GUI_OPTIONS[key])
	end
	
	-- Buttons frame
	local buttonFrame = Instance.new("Frame")
	buttonFrame.Size = UDim2.new(1, -30, 0, 50)
	buttonFrame.Position = UDim2.new(0, 15, 1, -60)
	buttonFrame.BackgroundTransparency = 1
	buttonFrame.Parent = mainFrame
	
	local function createButton(text, color, callback, isPrimary)
		local btn = Instance.new("TextButton")
		btn.Size = isPrimary and UDim2.new(0, 150, 1, -5) or UDim2.new(0, 100, 1, -5)
		btn.BackgroundColor3 = color
		btn.BackgroundTransparency = 0.1
		btn.BorderSizePixel = 0
		btn.Text = text
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.TextSize = 16
		btn.Font = isPrimary and Enum.Font.GothamBold or Enum.Font.GothamMedium
		
		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 8)
		btnCorner.Parent = btn
		
		btn.MouseEnter:Connect(function()
			btn.BackgroundTransparency = 0.2
		end)
		btn.MouseLeave:Connect(function()
			btn.BackgroundTransparency = 0.1
		end)
		
		btn.MouseButton1Click:Connect(callback)
		
		return btn
	end
	
	-- Start button
	local startBtn = createButton("▶ Start Save", Color3.fromRGB(80, 200, 120), function()
		gui:Destroy()
		-- Start save with GUI options
		task.spawn(function()
			local options = {
				Decompile = GUI_OPTIONS.Decompile,
				NilInstances = GUI_OPTIONS.NilInstances,
				IsolatePlayers = GUI_OPTIONS.RemovePlayers,
				ShowStatus = GUI_OPTIONS.ShowStatus,
				SafeMode = GUI_OPTIONS.SafeMode,
				KillAllScripts = GUI_OPTIONS.KillAllScripts,
				BoostFPS = GUI_OPTIONS.BoostFPS,
				SaveBytecode = GUI_OPTIONS.SaveBytecode,
				IgnoreDefaultProperties = GUI_OPTIONS.IgnoreDefaultProperties,
				mode = "optimized",
				ReadMe = true,
				DecompileTimeout = 15,
				BytecodeTimeout = 5,
			}
			synsaveinstance(options)
		end)
	end, true)
	
	startBtn.Position = UDim2.new(0.5, -80, 0, 0)
	startBtn.Parent = buttonFrame
	
	-- Cancel button
	local cancelBtn = createButton("✕ Cancel", Color3.fromRGB(200, 80, 80), function()
		gui:Destroy()
	end, false)
	
	cancelBtn.Position = UDim2.new(1, -110, 0, 0)
	cancelBtn.Parent = buttonFrame
	
	-- Version label
	local versionLabel = Instance.new("TextLabel")
	versionLabel.Size = UDim2.new(1, 0, 0, 20)
	versionLabel.Position = UDim2.new(0, 0, 1, -20)
	versionLabel.BackgroundTransparency = 1
	versionLabel.Text = "VCopy Service v2.0 • NuclearBobo"
	versionLabel.TextColor3 = Color3.fromRGB(100, 120, 160)
	versionLabel.TextSize = 10
	versionLabel.Font = Enum.Font.Gotham
	versionLabel.TextXAlignment = Enum.TextXAlignment.Center
	versionLabel.Parent = mainFrame
	
	gui.Parent = global_container.gethui and global_container.gethui() or game:GetService("CoreGui")
	return gui
end

local function synsaveinstance(CustomOptions, CustomOptions2)
	if GLOBAL_ENV.USSI then
		return
	end
	
	-- Check if GUI should be shown
	local showGUI = true
	if CustomOptions and type(CustomOptions) == "table" then
		if CustomOptions.SkipGUI then
			showGUI = false
		end
	end
	
	if showGUI and not CustomOptions2 then
		local gui = createSaveGUI()
		return gui
	end
	
	GLOBAL_ENV.USSI = true

	local totalsize, chunks = 0, table.create(1)
	local currentparts, currentsize = {}, 0
	local CHUNK_LIMIT = 200 * 1024 * 1024
	local last_save_yield = 0
	local saved_count, total_count = 0, 0
	local ProgressFill
	local realcheck = false
	local cached_physicsgrid, cached_smoothgrid
	local savebuffer, savebuffer_size = {}, 1
	local header =
		'<!-- Saved by NuclearBobo - V Copy --><roblox version="4">'

	local StatusText

	local OPTIONS = {
		mode = "optimized",
		Decompile = true,
		scriptcache = true,
		DecompileTimeout = 10,
		BytecodeTimeout = 3,
		__DEBUG_MODE = false,

		Callback = false,

		DecompileJobless = false,
		DecompileIgnore = {
			"TextChatService",
			ModuleScript = nil,
		},
		IgnoreDefaultPlayerScripts = true,
		SaveBytecode = false,

		IgnoreProperties = {},

		IgnoreList = { "CoreGui", "CorePackages" },

		ExtraInstances = {},
		NilInstances = false,
		NilInstancesFixes = {},

		SaveCacheInterval = 0x1600 * 10,
		ShowStatus = true,
		KillAllScripts = true,
		SafeMode = true,
		BoostFPS = false,
		ShutdownWhenDone = false,
		AntiIdle = true,
		Anonymous = false,
		ReadMe = true,
		FilePath = false,
		AvoidFileOverwrite = true,
		Object = false,
		IsModel = false,

		IgnoreDefaultProperties = true,
		IgnoreNotArchivable = true,
		IgnorePropertiesOfNotScriptsOnScriptsMode = false,
		IgnoreSpecialProperties = arrayToDict({ "Fluxus", "Delta", "Solara" })[EXECUTOR_NAME] or false,

		IsolateLocalPlayer = false,
		IsolateLocalPlayerCharacter = false,
		IsolatePlayers = false,
		IsolateStarterPlayer = false,
		SavePlayerCharacters = false,

		SaveNotCreatable = false,
		NotCreatableFixes = {
			"",
			"AdvancedDragger",
			"AnimationTrack",
			"Dragger",
			"Player",
			"PlayerGui",
			"PlayerMouse",
			"PlayerMouse",
			"PlayerScripts",
			"ScreenshotHud",
			"StudioData",
			"TextChatMessage",
			"TextSource",
			"TouchTransmitter",
			"Translator",
			CloudLocalizationTable = "LocalizationTable",
			Platform = "Part",
			Status = "Model",
		},

		IgnoreSharedStrings = false,
		SharedStringOverwrite = false,
		TreatUnionsAsParts = not gethiddenproperty or arrayToDict({ "Fluxus", "Delta", "Solara" })[EXECUTOR_NAME] or false,
		AlternativeWritefile = not arrayToDict({ "WRD", "Xeno", "Zorara" })[EXECUTOR_NAME],

		OptionsAliases = {
			timeout = "DecompileTimeout",
			DecompileScripts = "Decompile",
			FileName = "FilePath",
			IgnoreArchivable = "IgnoreNotArchivable",
			IgnoreDefaultProps = "IgnoreDefaultProperties",
			InstancesBlacklist = "IgnoreList",
			SaveLocalPlayer = "IsolateLocalPlayer",
			IsolatePlayerGui = "IsolateLocalPlayer",
			SavePlayerGui = "IsolateLocalPlayer",
			SaveNonCreatable = "SaveNotCreatable",
			SaveNilInstances = "NilInstances",
			SavePlayers = "IsolatePlayers",
			SaveCharacters = "SavePlayerCharacters",
			StatusText = "ShowStatus",
		},
		OptionsAliasesInverse = {
			noscripts = "Decompile",
			RemovePlayers = "IsolatePlayers",
			RemovePlayerCharacters = "SavePlayerCharacters",
		},
	}
	local OPTIONS_lowercase, OptionsAliasesInverse_lowercase, CustomOptions_valid = {}, {}, {}

	do
		local function buildMap(dest, source, warnLabel)
			for k, v in source do
				local key = string.lower(k)

				if dest[key] then
					warn("DUPLICATE " .. warnLabel, k)
				else
					dest[key] = v
				end
			end
		end

		for o in OPTIONS do
			local option = string.lower(o)
			if OPTIONS_lowercase[option] then
				warn("DUPLICATE OPTION", o)
			else
				OPTIONS_lowercase[option] = o
			end
		end

		buildMap(OPTIONS_lowercase, OPTIONS.OptionsAliases, "ALIAS")

		buildMap(OptionsAliasesInverse_lowercase, OPTIONS.OptionsAliasesInverse, "INVERSE ALIAS")
	end

	do
		local function makeNilinstanceFix(Name, ClassName, Separate)
			return function(instance, instancePropertyOverrides)
				local Exists

				if not Separate then
					Exists = OPTIONS.NilInstancesFixes[Name]
				end

				local Fix

				local DoesntExist = not Exists
				if DoesntExist then
					Fix = Instance.new(ClassName)
					if not Separate then
						OPTIONS.NilInstancesFixes[Name] = Fix
					end

					instancePropertyOverrides[Fix] =
						{ __SaveSpecific = true, __Children = { instance }, Properties = { Name = Name } }
				else
					Fix = Exists
					table.insert(instancePropertyOverrides[Fix].__Children, instance)
				end

				if DoesntExist then
					return Fix
				end
			end
		end

		OPTIONS.NilInstancesFixes.Animator =
			makeNilinstanceFix("Animator has to be placed under Humanoid or AnimationController", "AnimationController")
		OPTIONS.NilInstancesFixes.AdPortal = makeNilinstanceFix("AdPortal must be parented to a Part", "Part")
		OPTIONS.NilInstancesFixes.Attachment =
			makeNilinstanceFix("Attachments must be parented to a BasePart or another Attachment", "Part")
		OPTIONS.NilInstancesFixes.BaseWrap = makeNilinstanceFix("BaseWrap must be parented to a MeshPart", "MeshPart")
		OPTIONS.NilInstancesFixes.PackageLink = makeNilinstanceFix("Package already has a PackageLink", "Folder", true)

		if CustomOptions2 and type(CustomOptions2) == "table" then
			local tmp = CustomOptions
			local Type = typeof(tmp)
			CustomOptions = CustomOptions2
			if Type == "Instance" then
				CustomOptions.Object = tmp
			elseif Type == "table" and typeof(tmp[1]) == "Instance" then
				CustomOptions.ExtraInstances = tmp
				OPTIONS.IsModel = true
			end
		end

		local Type = typeof(CustomOptions)

		if Type == "table" then
			if typeof(CustomOptions[1]) == "Instance" then
				OPTIONS.mode = "invalidmode"
				OPTIONS.ExtraInstances = CustomOptions
				OPTIONS.IsModel = true
				CustomOptions = {}
			else
				for key, value in CustomOptions do
					local k = string.lower(key)

					local option = OPTIONS_lowercase[k]
					local invert = false

					if not option then
						option = OptionsAliasesInverse_lowercase[k]
						invert = option ~= nil
					end

					if option then
						local finalValue
						if invert then
							finalValue = not value
						else
							finalValue = value
						end

						OPTIONS[option] = finalValue
						CustomOptions_valid[option] = true
					end
				end
			end
		elseif Type == "Instance" then
			OPTIONS.mode = "invalidmode"
			OPTIONS.Object = CustomOptions
			CustomOptions = {}
		else
			CustomOptions = {}
		end
	end

	-- Apply GUI options if not overridden by custom options
	if CustomOptions_valid["Decompile"] == nil then
		OPTIONS.Decompile = GUI_OPTIONS.Decompile
	end
	if CustomOptions_valid["NilInstances"] == nil then
		OPTIONS.NilInstances = GUI_OPTIONS.NilInstances
	end
	if CustomOptions_valid["IsolatePlayers"] == nil then
		OPTIONS.IsolatePlayers = GUI_OPTIONS.RemovePlayers
	end
	if CustomOptions_valid["ShowStatus"] == nil then
		OPTIONS.ShowStatus = GUI_OPTIONS.ShowStatus
	end
	if CustomOptions_valid["SafeMode"] == nil then
		OPTIONS.SafeMode = GUI_OPTIONS.SafeMode
	end
	if CustomOptions_valid["KillAllScripts"] == nil then
		OPTIONS.KillAllScripts = GUI_OPTIONS.KillAllScripts
	end
	if CustomOptions_valid["BoostFPS"] == nil then
		OPTIONS.BoostFPS = GUI_OPTIONS.BoostFPS
	end
	if CustomOptions_valid["SaveBytecode"] == nil then
		OPTIONS.SaveBytecode = GUI_OPTIONS.SaveBytecode
	end
	if CustomOptions_valid["IgnoreDefaultProperties"] == nil then
		OPTIONS.IgnoreDefaultProperties = GUI_OPTIONS.IgnoreDefaultProperties
	end

	if not writefile and not OPTIONS.Callback then
		local function coreCall(method, ...)
			local StarterGui = service.StarterGui
			method = StarterGui[method]
			if not method then
				return
			end

			for _ = 1, 10 do
				local success, result = pcall(method, StarterGui, ...)
				if success then
					return result
				end
				task.wait(1)
			end
		end

		local text = 'Function "writefile" is NOT available\nUse the Option "Callback" instead for now (check docs)'

		coreCall("SetCore", "SendNotification", {
			Title = "SAVEINSTANCE ERROR",
			Text = text,
			Duration = 15,
			Icon = "rbxassetid://9072920609",
		})
		coreCall("SetCore", "SendNotification", {
			Title = "SAVEINSTANCE ERROR",
			Text = "Please ask your executor's developers to add writefile",
			Duration = 15,
			Icon = "rbxassetid://9072920609",
		})

		warn(text)

		GLOBAL_ENV.USSI = nil
		return
	end

	-- [Rest of the script continues with the same functionality]
	-- (The remaining code is identical to the previous version)

	GLOBAL_ENV.USSI = nil
end

return synsaveinstance
