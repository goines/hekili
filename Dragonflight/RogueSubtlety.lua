-- RogueSubtlety.lua
-- November 2022

if UnitClassBase( "player" ) ~= "ROGUE" then return end

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State

local insert, wipe = table.insert, table.wipe

local spec = Hekili:NewSpecialization( 261 )

spec:RegisterResource( Enum.PowerType.Energy, {
    shadow_techniques = {
        last = function () return state.query_time end,
        interval = function () return state.time_to_sht[5] end,
        value = 8,
        stop = function () return state.time_to_sht[5] == 0 or state.time_to_sht[5] == 3600 end,
    }
} )

spec:RegisterResource( Enum.PowerType.ComboPoints, {
    shadow_techniques = {
        last = function () return state.query_time end,
        interval = function () return state.time_to_sht[5] end,
        value = 1,
        stop = function () return state.time_to_sht[5] == 0 or state.time_to_sht[5] == 3600 end,
    },

    --[[ shuriken_tornado = {
        aura = "shuriken_tornado",
        last = function ()
            local app = state.buff.shuriken_tornado.applied
            local t = state.query_time

            return app + floor( ( t - app ) / 0.95 ) * 0.95
        end,

        stop = function( x ) return state.buff.shuriken_tornado.remains == 0 end,

        interval = 0.95,
        value = function () return state.active_enemies + ( state.buff.shadow_blades.up and 1 or 0 ) end,
    }, ]]
} )


-- Talents
spec:RegisterTalents( {
    -- Rogue
    acrobatic_strikes          = { 90752, 196924, 1 }, -- Increases the range of your melee attacks by 3 yds.
    alacrity                   = { 90751, 193539, 2 }, -- Your finishing moves have a 5% chance per combo point to grant 1% Haste for 15 sec, stacking up to 5 times.
    atrophic_poison            = { 90763, 381637, 1 }, -- Coats your weapons with a Non-Lethal Poison that lasts for 1 |4hour:hrs;. Each strike has a 30% chance of poisoning the enemy, reducing their damage by 3.0% for 10 sec.
    blackjack                  = { 90696, 379005, 1 }, -- Enemies have 30% reduced damage and healing for 6 sec after Blind or Sap's effect on them ends.
    -- cheat_death                = { 90747, 31230 , 1 }, -- Fatal attacks instead reduce you to 7% of your maximum health. For 3 sec afterward, you take 85% reduced damage. Cannot trigger more often than once per 6 min.
    cheat_death                = { 90742, 31230 , 1 }, -- Fatal attacks instead reduce you to 7% of your maximum health. For 3 sec afterward, you take 85% reduced damage. Cannot trigger more often than once per 6 min.
    cloak_of_shadows           = { 90697, 31224 , 1 }, -- Provides a moment of magic immunity, instantly removing all harmful spell effects. The cloak lingers, causing you to resist harmful spells for 5 sec.
    cold_blood                 = { 90748, 382245, 1 }, -- Increases the critical strike chance of your next damaging ability by 100%.
    deadened_nerves            = { 90743, 231719, 1 }, -- Physical damage taken reduced by 3%.
    deadly_precision           = { 90760, 381542, 2 }, -- Increases the critical strike chance of your attacks that generate combo points by 5%.
    deeper_stratagem           = { 90750, 193531, 1 }, -- Gain 1 additional max combo point. Your finishing moves that consume more than 5 combo points have increased effects, and your finishing moves deal 5% increased damage.
    echoing_reprimand          = { 90639, 385616, 1 }, -- Deal 1,799 Arcane damage to an enemy, extracting their anima to Animacharge a combo point for 45 sec. Damaging finishing moves that consume the same number of combo points as your Animacharge function as if they consumed 7 combo points. Awards 2 combo points.
    elusiveness                = { 90742, 79008 , 1 }, -- Evasion also reduces damage taken by 10%, and Feint also reduces non-area-of-effect damage taken by 20%.
    evasion                    = { 90764, 5277  , 1 }, -- Increases your dodge chance by 100% for 10 sec.
    find_weakness              = { 90690, 91023 , 2 }, -- Your Stealth abilities reveal a flaw in your target's defenses, causing all your attacks to bypass 15% of that enemy's armor for 10 sec.
    fleet_footed               = { 90762, 378813, 1 }, -- Movement speed increased by 15%.
    gouge                      = { 90741, 1776  , 1 }, -- Gouges the eyes of an enemy target, incapacitating for 4 sec. Damage will interrupt the effect. Must be in front of your target. Awards 1 combo point.
    improved_ambush            = { 90692, 381620, 1 }, -- Shadowstrike generates 1 additional combo point.
    improved_sprint            = { 90746, 231691, 1 }, -- Reduces the cooldown of Sprint by 60 sec.
    improved_wound_poison      = { 90637, 319066, 1 }, -- Wound Poison can now stack 2 additional times.
    iron_stomach               = { 90744, 193546, 1 }, -- Increases the healing you receive from Crimson Vial, healing potions, and healthstones by 25%.
    leeching_poison            = { 90758, 280716, 1 }, -- Adds a Leeching effect to your Lethal poisons, granting you 5% Leech.
    lethality                  = { 90749, 382238, 2 }, -- Critical strike chance increased by 1%. Critical strike damage bonus of your attacks that generate combo points increased by 10%.
    marked_for_death           = { 90750, 137619, 1 }, -- Marks the target, instantly generating 5 combo points. Cooldown reset if the target dies within 1 min.
    master_poisoner            = { 90636, 378436, 1 }, -- Increases the non-damaging effects of your weapon poisons by 20%.
    nightstalker               = { 90693, 14062 , 2 }, -- While Stealth or Shadow Dance is active, your abilities deal 4% more damage.
    nimble_fingers             = { 90745, 378427, 1 }, -- Energy cost of Feint and Crimson Vial reduced by 10.
    numbing_poison             = { 90763, 5761  , 1 }, -- Coats your weapons with a Non-Lethal Poison that lasts for 1 |4hour:hrs;. Each strike has a 30% chance of poisoning the enemy, clouding their mind and slowing their attack and casting speed by 15% for 10 sec.
    prey_on_the_weak           = { 90755, 131511, 1 }, -- Enemies disabled by your Cheap Shot or Kidney Shot take 10% increased damage from all sources for 6 sec.
    recuperator                = { 90640, 378996, 1 }, -- Slice and Dice heals you for up to 1% of your maximum health per 2 sec.
    resounding_clarity         = { 90638, 381622, 1 }, -- Echoing Reprimand Animacharges 2 additional combo points.
    reverberation              = { 90638, 394332, 1 }, -- Echoing Reprimand's damage is increased by 75%.
    rushed_setup               = { 90754, 378803, 1 }, -- The Energy costs of Kidney Shot, Cheap Shot, Sap, and Distract are reduced by 20%.
    seal_fate                  = { 90757, 14190 , 2 }, -- When you critically strike with a melee attack that generates combo points, you have a 50% chance to gain an additional combo point per critical strike.
    shadow_dance               = { 90689, 185313, 1 }, -- Allows use of all Stealth abilities and grants all the combat benefits of Stealth for 8 sec, and increases damage by 30%. Effect not broken from taking damage or attacking. If you already know Shadow Dance, instead gain 1 additional charge of Shadow Dance.
    shadowrunner               = { 90687, 378807, 1 }, -- While Stealth or Shadow Dance is active, you move 20% faster.
    shadowstep                 = { 90695, 36554 , 1 }, -- Step through the shadows to appear behind your target and gain 70% increased movement speed for 2 sec. If you already know Shadowstep, instead gain 1 additional charge of Shadowstep.
    soothing_darkness          = { 90691, 393970, 1 }, -- You are healed for 30% of your maximum health over 6 sec after gaining Vanish or Shadow Dance.
    subterfuge                 = { 90688, 108208, 1 }, -- Your abilities requiring Stealth can still be used for 3 sec after Stealth breaks.
    thiefs_versatility         = { 90753, 381619, 2 }, -- Versatility increased by 2%.
    thistle_tea                = { 90756, 381623, 1 }, -- Restore 100 Energy. Mastery increased by 19.6% for 6 sec.
    tight_spender              = { 90694, 381621, 1 }, -- Energy cost of finishing moves reduced by 10%.
    tricks_of_the_trade        = { 90686, 57934 , 1 }, -- Redirects all threat you cause to the targeted party or raid member, beginning with your next damaging attack within the next 30 sec and lasting 6 sec.
    unbreakable_stride         = { 90747, 400804, 1 }, -- Reduces the duration of movement slowing effects 30%.
    vigor                      = { 90759, 14983 , 1 }, -- Increases your maximum Energy by 50 and your Energy regeneration by 10%.
    virulent_poisons           = { 90761, 381543, 1 }, -- Increases the damage of your weapon poisons by 10%.

    -- Subtlety
    black_powder               = { 90712, 319175, 1 }, -- Finishing move that launches explosive Black Powder at all nearby enemies dealing Physical damage. Deals reduced damage beyond 8 targets. All nearby targets with your Find Weakness suffer an additional 20% damage as Shadow. 1 point : 166 damage 2 points: 332 damage 3 points: 497 damage 4 points: 663 damage 5 points: 829 damage 6 points: 995 damage
    blind                      = { 90684, 2094  , 1 }, -- Blinds the target, causing it to wander disoriented for 1 min. Damage will interrupt the effect. Limit 1.
    cloaked_in_shadows         = { 90733, 382515, 1 }, -- Vanish grants you a shield for 6 sec, absorbing damage equal to 30% of your maximum health.
    danse_macabre              = { 90730, 382528, 1 }, -- Shadow Dance increases the damage of your attacks that generate or spend combo points by 6%, increased by an additional 6% for each different attack used.
    dark_brew                  = { 90719, 382504, 1 }, -- Your attacks that deal Nature or Bleed damage now deal Shadow instead. Shadow damage increased by 10%.
    dark_shadow                = { 90732, 245687, 2 }, -- Shadow Dance increases damage by an additional 15%.
    deepening_shadows          = { 90724, 185314, 1 }, -- Your finishing moves reduce the remaining cooldown on Shadow Dance by 0.7 sec per combo point spent.
    deeper_daggers             = { 90721, 382517, 2 }, -- Eviscerate and Black Powder increase your Shadow damage dealt by 10% for 8 sec.
    fade_to_nothing            = { 90733, 382514, 1 }, -- Movement speed increased by 20% and damage taken reduced by 10% for 8 sec after gaining Stealth, Vanish, or Shadow Dance.
    finality                   = { 90720, 382525, 2 }, -- Eviscerate, Rupture, and Black Powder increase the damage of the next use of the same finishing move by 15%. Lasts 30 sec.
    flagellation               = { 90718, 384631, 1 }, -- Lash the target for 681 Shadow damage, causing each combo point spent within 12 sec to lash for an additional 136. Dealing damage with Flagellation increases your Mastery by 2.5%, persisting 12 sec after their torment fades.
    gloomblade                 = { 90699, 200758, 1 }, -- Punctures your target with your shadow-infused blade for 890 Shadow damage, bypassing armor. Critical strikes apply Find Weakness for 10 sec. Awards 1 combo point.
    improved_backstab          = { 90739, 319949, 1 }, -- Backstab has 15% increased critical strike chance. When you are behind your target, Backstab critical strikes now also expose a flaw in their defenses, applying Find Weakness for 10 sec.
    improved_shadow_dance      = { 90734, 393972, 2 }, -- Shadow Dance has 1 sec increased duration.
    improved_shadow_techniques = { 90736, 394023, 1 }, -- Shadow Techniques generates 3 additional Energy.
    improved_shuriken_storm    = { 90710, 319951, 1 }, -- Shuriken Storm has an additional 15% chance to crit, and its critical strikes apply Find Weakness for 10 sec.
    inevitability              = { 90708, 382512, 1 }, -- Backstab and Shadowstrike extend the duration of your Symbols of Death by 0.5 sec.
    invigorating_shadowdust    = { 90706, 382523, 2 }, -- Vanish reduces the remaining cooldown of your other Rogue abilities by 15.0 sec.
    lingering_shadow           = { 90731, 382524, 2 }, -- After Shadow Dance ends, Backstab deals an additional 50% damage as Shadow, fading by 2.8% per sec.
    master_of_shadows          = { 90735, 196976, 1 }, -- Gain 25 Energy over 3 sec when you enter Stealth or activate Shadow Dance.
    night_terrors              = { 90711, 277953, 1 }, -- Shuriken Storm reduces enemies' movement speed by 50% for 8 sec.
    perforated_veins           = { 90707, 382518, 2 }, -- Shadowstrike increases the damage of your next Backstab by 20%. Max 5 stacks.
    planned_execution          = { 90703, 382508, 2 }, -- Symbols of Death increases your critical strike chance by 5%.
    premeditation              = { 90737, 343160, 1 }, -- After entering Stealth, your next Shadowstrike grants up to 10 sec of Slice and Dice, and generates 2 additional combo points if Slice and Dice is active.
    quick_decisions            = { 90728, 382503, 1 }, -- Shadowstep's cooldown is reduced by 20%, and its maximum range is increased by 20%.
    relentless_strikes         = { 90709, 58423 , 1 }, -- Your finishing moves generate 5 Energy per combo point spent.
    replicating_shadows        = { 90717, 382506, 1 }, -- Rupture deals an additional 20% damage as Shadow and applies to 1 additional enemy within 8 yds.
    sap                        = { 90685, 6770  , 1 }, -- Incapacitates a target not in combat for 1 min. Only works on Humanoids, Beasts, Demons, and Dragonkin. Damage will revive the target. Limit 1.
    secret_stratagem           = { 90722, 394320, 1 }, -- Gain 1 additional max combo point. Your finishing moves that consume more than 5 combo points have increased effects, and your finishing moves deal 5% increased damage.
    secret_technique           = { 90715, 280719, 1 }, -- Finishing move that creates shadow clones of yourself. You and your shadow clones each perform a piercing attack on all enemies near your target, dealing Physical damage to the primary target and reduced damage to other targets. 1 point : 892 total damage 2 points: 1,784 total damage 3 points: 2,676 total damage 4 points: 3,568 total damage 5 points: 4,460 total damage 6 points: 5,352 total damage Cooldown is reduced by 1 sec for every combo point you spend.
    sepsis                     = { 90704, 385408, 1 }, -- Infect the target's blood, dealing 5,513 Nature damage over 10 sec and gaining 1 use of any Stealth ability. If the target survives its full duration, they suffer an additional 2,029 damage and you gain 1 additional use of any Stealth ability for 10 sec. Cooldown reduced by 30 sec if Sepsis does not last its full duration. Awards 1 combo point.
    shadow_blades              = { 90726, 121471, 1 }, -- Draws upon surrounding shadows to empower your weapons, causing your combo point generating abilities to generate 1 additional combo point and deal 50% additional damage as Shadow for 20 sec.
    shadow_focus               = { 90727, 108209, 1 }, -- Abilities cost 15% less Energy while Stealth or Shadow Dance is active.
    shadowed_finishers         = { 90723, 382511, 2 }, -- Eviscerate and Black Powder deal an additional 20% damage as Shadow to targets with your Find Weakness active.
    shadowstep_2               = { 90729, 36554 , 1 }, -- Step through the shadows to appear behind your target and gain 70% increased movement speed for 2 sec. If you already know Shadowstep, instead gain 1 additional charge of Shadowstep.
    shiv                       = { 90740, 5938  , 1 }, -- Attack with your off-hand, dealing 397 Physical damage, dispelling all enrage effects and applying a concentrated form of your active Non-Lethal poison. Awards 1 combo point.
    shot_in_the_dark           = { 90698, 257505, 1 }, -- After entering Stealth or Shadow Dance, your next Cheap Shot is free.
    shrouded_in_darkness       = { 90700, 382507, 1 }, -- Shroud of Concealment increases the movement speed of all party and raid members within its radius by 100%.
    shuriken_tornado           = { 90716, 277925, 1 }, -- Focus intently, then release a Shuriken Storm every sec for the next 4 sec.
    silent_storm               = { 90714, 385722, 1 }, -- Gaining Stealth, Vanish, or Shadow Dance causes your next Shuriken Storm to have 100% increased chance to critically strike.
    stiletto_staccato          = { 90725, 382509, 1 }, -- Shadow Techniques now also reduces the remaining cooldown of Shadow Blades by 1.0 sec.
    swift_death                = { 90701, 394309, 1 }, -- Symbols of Death has 5 sec reduced cooldown.
    the_first_dance            = { 90735, 382505, 1 }, -- Activating Shadow Dance generates 4 combo points.
    the_rotten                 = { 90705, 382015, 1 }, -- After activating Symbols of Death, your next Shadowstrike or Backstab deals 50% increased damage, generates 4 additional combo points, and is guaranteed to critically strike.
    veiltouched                = { 90713, 382017, 1 }, -- Your abilities deal 5% increased magic damage.
    weaponmaster               = { 90738, 193537, 1 }, -- Shadowstrike and Backstab have a 15% chance to hit the target twice each time they deal damage.
    without_a_trace            = { 90702, 382513, 1 }, -- Vanish has 1 additional charge.
} )


-- PvP Talents
spec:RegisterPvpTalents( {
    control_is_king    = 5529, -- (354406) Cheap Shot grants Slice and Dice for 15 sec and Kidney Shot restores 10 Energy per combo point spent.
    dagger_in_the_dark = 846 , -- (198675) Each second while Stealth is active, nearby enemies within 10 yards take an additional 5% damage from your next Shadowstrike for 10 sec. Stacks up to 8 times.
    death_from_above   = 3462, -- (269513) Finishing move that empowers your weapons with energy to performs a deadly attack. You leap into the air and Eviscerate your target on the way back down, with such force that it has a 10% stronger effect.
    dismantle          = 5406, -- (207777) Disarm the enemy, preventing the use of any weapons or shield for 6 sec.
    distracting_mirage = 5411, -- (354661) Distract slows affected enemies by 30% and creates a Mirage that follows an enemy for 8 sec. Reactivate Distract to teleport to your Mirage's location.
    maneuverability    = 3447, -- (197000) Sprint removes all root effects and suppresses all movement-slowing effects for 4 sec when used.
    shadowy_duel       = 153 , -- (207736) You lock your target into a duel contained in the shadows, removing both of you from the eyes of onlookers for 5 sec. Allows access to Stealth-based abilities.
    silhouette         = 856 , -- (197899) Shadowstep's cooldown is reduced by 67% when cast on a friendly target.
    smoke_bomb         = 1209, -- (359053) Creates a cloud of thick smoke in an 8 yard radius around the Rogue for 5 sec. Enemies are unable to target into or out of the smoke cloud.
    thick_as_thieves   = 5409, -- (221622) Tricks of the Trade now increases the friendly target's damage by 15% for 6 sec.
    thiefs_bargain     = 146 , -- (354825) The cooldowns of Shadow Blades, Vanish, and Feint are reduced by 33%, but using one reduces your damage by 10% for 6 sec.
    veil_of_midnight   = 136 , -- (198952) You remain enveloped by the shadows for 2 sec after Stealth or Vanish fades, increasing dodge chance by 100%.
} )


-- Auras
spec:RegisterAuras( {
    danse_macabre = {
        id = 393969,
        duration = function () return talent.subterfuge.enabled and 9 or 8 end,
        max_stack = 1
    },
    finality_black_powder = {
        id = 385948,
        duration = 30,
        max_stack = 1
    },
    finality_eviscerate = {
        id = 385949,
        duration = 30,
        max_stack = 1
    },
    finality_rupture = {
        id = 385951,
        duration = 30,
        max_stack = 1,
    },
    flagellation = {
        id = 384631,
        duration = 12,
        max_stack = 30,
        copy = 323654
    },
    flagellation_persist = {
        id = 394758,
        duration = 12,
        max_stack = 30,
        copy = { "flagellation_buff", 345569 }
    },
    -- Talent: $?s200758[Gloomblade][Backstab] deals an additional $s1% damage as Shadow.
    -- https://wowhead.com/beta/spell=385960
    lingering_shadow = {
        id = 385960,
        duration = 18,
        tick_time = 1,
        max_stack = 50
    },
    master_of_shadows = {
        id = 196980,
        duration = 3,
        max_stack = 1,
    },
    premeditation = {
        id = 343173,
        duration = 3600,
        max_stack = 1,
    },
    secret_technique = {
        duration = 1.3,
        max_stack = 1,
        generate = function( t )
            local applied = action.secret_technique.lastCast
            local expires = applied + 1.3

            if query_time < expires then
                t.name = t.name or GetSpellInfo( 280719 ) or "secret_technique"
                t.count = 1
                t.applied = applied
                t.duration = 1.3
                t.expires = expires
                t.caster = "player"
                return
            end

            t.name = t.name or GetSpellInfo( 280719 ) or "secret_technique"
            t.count = 0
            t.applied = 0
            t.duration = 1.3
            t.expires = 0
            t.caster = "nobody"
        end,
    },
    -- Talent: Combo point generating abilities generate $s2 additional combo point and deal $s1% additional damage as Shadow.
    -- https://wowhead.com/beta/spell=121471
    shadow_blades = {
        id = 121471,
        duration = 20,
        max_stack = 1
    },
    shot_in_the_dark = {
        id = 257506,
        duration = 3600,
        max_stack = 1,
    },
    -- Talent: Releasing a Shuriken Storm every sec.
    -- https://wowhead.com/beta/spell=277925
    shuriken_tornado = {
        id = 277925,
        duration = 4,
        max_stack = 1
    },
    silent_storm = {
        id = 385727,
        duration = 3600,
        max_stack = 1
    },
    subterfuge = {
        id = 115192,
        duration = 3,
        max_stack = 1,
    },
    symbols_of_death_crit = {
        id = 227151,
        duration = 10,
        max_stack = 1,
        copy = "symbols_of_death_autocrit"
    },
    -- Talent: Your next Shadowstrike or $?s200758[Gloomblade][Backstab] deals $s3% increased damage, generates $s1 additional combo points, and is guaranteed to critically strike.
    -- https://wowhead.com/beta/spell=394203
    the_rotten = {
        id = 394203,
        duration = 30,
        max_stack = 1,
        copy = 341134
    },

    -- Azerite Powers
    blade_in_the_shadows = {
        id = 279754,
        duration = 60,
        max_stack = 10,
    },
    nights_vengeance = {
        id = 273424,
        duration = 8,
        max_stack = 1,
    },
    perforate = {
        id = 277720,
        duration = 12,
        max_stack = 1
    },
    replicating_shadows = {
        id = 286131,
        duration = 1,
        max_stack = 50
    },
    the_first_dance = {
        id = 278981,
        duration = function () return buff.shadow_dance.duration end,
        max_stack = 1,
    },

    -- Conduit
    deeper_daggers = {
        id = 341550,
        duration = 5,
        max_stack = 1
    },
    perforated_veins = {
        id = 341572,
        duration = 12,
        max_stack = 3
    },

    -- Legendaries (Shadowlands)
    deathly_shadows = {
        id = 341202,
        duration = 15,
        max_stack = 1,
    },
    master_assassins_mark = {
        id = 340094,
        duration = 4,
        max_stack = 1
    },
} )


local true_stealth_change = 0
local emu_stealth_change = 0

spec:RegisterEvent( "UPDATE_STEALTH", function ()
    true_stealth_change = GetTime()
end )


local stealth = {
    rogue   = { "stealth", "vanish", "shadow_dance", "subterfuge" },
    mantle  = { "stealth", "vanish" },
    sepsis  = { "sepsis_buff" },
    all     = { "stealth", "vanish", "shadow_dance", "subterfuge", "shadowmeld", "sepsis_buff" }
}


spec:RegisterStateTable( "stealthed", setmetatable( {}, {
    __index = function( t, k )
        if k == "basic" then
            return buff.stealth.up or buff.vanish.up
        elseif k == "basic_remains" then
            return max( buff.stealth.remains, buff.vanish.remains )

        elseif k == "rogue" then
            return buff.stealth.up or buff.vanish.up or buff.shadow_dance.up or buff.subterfuge.up
        elseif k == "rogue_remains" then
            return max( buff.stealth.remains, buff.vanish.remains, buff.shadow_dance.remains, buff.subterfuge.remains )

        elseif k == "mantle" then
            return buff.stealth.up or buff.vanish.up
        elseif k == "mantle_remains" then
            return max( buff.stealth.remains, buff.vanish.remains )

        elseif k == "sepsis" then
            return buff.sepsis_buff.up
        elseif k == "sepsis_remains" then
            return buff.sepsis_buff.remains

        elseif k == "all" then
            return buff.stealth.up or buff.vanish.up or buff.shadow_dance.up or buff.subterfuge.up or buff.shadowmeld.up or buff.sepsis_buff.up
        elseif k == "remains" or k == "all_remains" then
            return max( buff.stealth.remains, buff.vanish.remains, buff.shadow_dance.remains, buff.subterfuge.remains, buff.shadowmeld.remains, buff.sepsis_buff.remains )
        end

        return false
    end
} ) )


local last_mh = 0
local last_oh = 0
local last_shadow_techniques = 0
local swings_since_sht = 0

local danse_ends = 0
local danse_macabre_actual = {}

spec:RegisterCombatLogEvent( function( _, subtype, _, sourceGUID, sourceName, _, _, destGUID, destName, destFlags, _, spellID, spellName, _, amount, interrupt, a, b, c, d, offhand, multistrike )
    if not sourceGUID == state.GUID then return end

    if subtype == "SPELL_ENERGIZE" and spellID == 196911 then
        last_shadow_techniques = GetTime()
        swings_since_sht = 0

    elseif subtype:sub( 1, 5 ) == "SWING" and not multistrike then
        if subtype == "SWING_MISSED" then
            offhand = spellName
        end

        local now = GetTime()

        if now > last_shadow_techniques + 3 then
            swings_since_sht = swings_since_sht + 1
        end

        if offhand then last_mh = GetTime()
        else last_mh = GetTime() end
    end

    if state.talent.danse_macabre.enabled and subtype == "SPELL_CAST_SUCCESS" then
        if spellID == 185313 then
            -- Start fresh with each Shadow Dance.
            wipe( danse_macabre_actual )
            danse_ends = GetTime() + 8

        elseif danse_ends > GetTime() then
            local ability = class.abilities[ spellID ]

            if ability then
                danse_macabre_actual[ ability.key ] = true
            end
        end
    end
end )


local sht = {}

spec:RegisterStateTable( "time_to_sht", setmetatable( {}, {
    __index = function( t, k )
        local n = tonumber( k )
        n = n - ( n % 1 )

        if not n or n > 5 then return 3600 end

        if n <= swings_since_sht then return 0 end

        local mh_speed = swings.mainhand_speed
        local mh_next = ( swings.mainhand > now - 3 ) and ( swings.mainhand + mh_speed ) or now + ( mh_speed * 0.5 )

        local oh_speed = swings.offhand_speed
        local oh_next = ( swings.offhand > now - 3 ) and ( swings.offhand + oh_speed ) or now

        table.wipe( sht )

        if mh_speed and mh_speed > 0 then
            for i = 1, 4 do
                insert( sht, mh_next + ( i * mh_speed ) )
            end
        end

        if oh_speed and oh_speed > 0 then
            for i = 1, 4 do
                insert( sht, oh_next + ( i * oh_speed ) )
            end
        end

        local i = 1

        while( sht[i] ) do
            if sht[i] < last_shadow_techniques + 3 then
                table.remove( sht, i )
            else
                i = i + 1
            end
        end

        if #sht > 0 and n - swings_since_sht < #sht then
            table.sort( sht )
            return max( 0, sht[ n - swings_since_sht ] - query_time )
        else
            return 3600
        end
    end
} ) )

spec:RegisterStateTable( "time_to_sht_plus", setmetatable( {}, {
    __index = function( t, k )
        local n = tonumber( k )
        n = n - ( n % 1 )

        if not n or n > 5 then return 3600 end
        local val = time_to_sht[k]

        -- Time of next attack instead.
        if val == 0 then
            local last = swings.mainhand
            local speed = swings.mainhand_speed
            local swing = 3600

            if last > 0 and speed > 0 then
                swing = last + ( ceil( ( query_time - last ) / speed ) * speed ) - query_time
            end

            last = swings.offhand
            speed = swings.offhand_speed

            if last > 0 and speed > 0 then
                swing = min( swing, last + ( ceil( ( query_time - last ) / speed ) * speed ) - query_time )
            end

            return swing
        end

        return val
    end,
} ) )


spec:RegisterStateExpr( "bleeds", function ()
    return ( debuff.garrote.up and 1 or 0 ) + ( debuff.rupture.up and 1 or 0 )
end )


spec:RegisterStateExpr( "cp_max_spend", function ()
    return combo_points.max
end )


spec:RegisterStateExpr( "effective_combo_points", function ()
    local c = combo_points.current or 0
    if not talent.echoing_reprimand.enabled and not covenant.kyrian then return c end
    if c < 2 or c > 5 then return c end
    if buff[ "echoing_reprimand_" .. c ].up then return 7 end
    return c
end )


-- Legendary from Legion, shows up in APL still.
spec:RegisterGear( "cinidaria_the_symbiote", 133976 )
spec:RegisterGear( "denial_of_the_halfgiants", 137100 )

local function comboSpender( amt, resource )
    if resource == "combo_points" then
        if amt > 0 then
            gain( 6 * amt, "energy" )
        end

        if talent.alacrity.enabled and amt >= 5 then
            addStack( "alacrity" )
        end

        if talent.secret_technique.enabled then
            cooldown.secret_technique.expires = max( 0, cooldown.secret_technique.expires - amt )
        end

        reduceCooldown( "shadow_dance", amt * ( talent.enveloping_shadows.enabled and 1.5 or 1 ) )

        if legendary.obedience.enabled and buff.flagellation_buff.up then
            reduceCooldown( "flagellation", amt )
        end
    end
end

spec:RegisterHook( "spend", comboSpender )
-- spec:RegisterHook( "spendResources", comboSpender )


spec:RegisterStateExpr( "mantle_duration", function ()
    return legendary.mark_of_the_master_assassin.enabled and 4 or 0
end )

spec:RegisterStateExpr( "master_assassin_remains", function ()
    if not legendary.mark_of_the_master_assassin.enabled then return 0 end

    if stealthed.mantle then return cooldown.global_cooldown.remains + 4
    elseif buff.master_assassins_mark.up then return buff.master_assassins_mark.remains end
    return 0
end )


-- We need to break stealth when we start combat from an ability.
spec:RegisterHook( "runHandler", function( ability )
    local a = class.abilities[ ability ]

    if stealthed.mantle and ( not a or a.startsCombat ) then
        if talent.subterfuge.enabled and stealthed.mantle then
            applyBuff( "subterfuge" )
        end

        if legendary.mark_of_the_master_assassin.enabled and stealthed.mantle then
            applyBuff( "master_assassins_mark", 4 )
        end

        if buff.stealth.up then
            setCooldown( "stealth", 2 )
        end
        removeBuff( "stealth" )
        removeBuff( "vanish" )
        removeBuff( "shadowmeld" )
    end

    if buff.shadow_dance.up and talent.danse_macabre.enabled then
        danse_macabre_tracker[ a.key ] = true
    end
end )


local ExpireSepsis = setfenv( function ()
    applyBuff( "sepsis_buff" )

    if legendary.toxic_onslaught.enabled then
        applyBuff( "adrenaline_rush", 10 )
        applyDebuff( "target", "vendetta", 10 )
    end
end, state )


spec:RegisterStateTable( "danse_macabre_tracker", setmetatable( {}, {
    __index = function( t, k )
        return false
    end,
} ) )

spec:RegisterStateExpr( "used_for_danse", function()
    if not talent.danse_macabre.enabled or buff.shadow_dance.down then return false end
    return danse_macabre_tracker[ this_action ]
end )


spec:RegisterHook( "reset_precast", function( amt, resource )
    if talent.danse_macabre.enabled then
        wipe( danse_macabre_tracker )
        if buff.shadow_dance.up then
            for k in pairs( danse_macabre_actual ) do
                danse_macabre_tracker[ k ] = true
            end
        end
    end

    if debuff.sepsis.up then
        state:QueueAuraExpiration( "sepsis", ExpireSepsis, debuff.sepsis.expires )
    end

    if buff.shuriken_tornado.up then
        local moment = buff.shuriken_tornado.expires
        while( moment > query_time ) do
            state:QueueAuraEvent( "shuriken_tornado", class.abilities.shuriken_storm.handler, moment, "AURA_PERIODIC" )
            moment = moment - 1
        end
    end

    class.abilities.apply_poison = class.abilities[ action.apply_poison_actual.next_poison ]

    if buff.cold_blood.up then setCooldown( "cold_blood", action.cold_blood.cooldown ) end
end )

spec:RegisterHook( "runHandler", function( ability )
    local a = class.abilities[ ability ]

    if stealthed.all and ( not a or a.startsCombat ) then
        if buff.stealth.up then
            setCooldown( "stealth", 2 )
        end

        if legendary.mark_of_the_master_assassin.enabled and stealthed.mantle then
            applyBuff( "master_assassins_mark" )
        end

        removeBuff( "stealth" )
        removeBuff( "shadowmeld" )
        removeBuff( "vanish" )
    end

    if buff.cold_blood.up and ( not a or a.startsCombat ) then
        removeBuff( "cold_blood" )
    end

    class.abilities.apply_poison = class.abilities[ action.apply_poison_actual.next_poison ]
end )

spec:RegisterUnitEvent( "UNIT_POWER_FREQUENT", "player", nil, function( event, unit, powerType )
    if powerType == "COMBO_POINTS" then
        Hekili:ForceUpdate( powerType, true )
    end
end )

spec:RegisterCycle( function ()
    if this_action == "marked_for_death" then
        if cycle_enemies == 1 or active_dot.marked_for_death >= cycle_enemies then return end -- As far as we can tell, MfD is on everything we care about, so we don't cycle.
        if debuff.marked_for_death.up then return "cycle" end -- If current target already has MfD, cycle.
        if target.time_to_die > 3 + Hekili:GetLowestTTD() and active_dot.marked_for_death == 0 then return "cycle" end -- If our target isn't lowest TTD, and we don't have to worry that the lowest TTD target is already MfD'd, cycle.
    end
end )

spec:RegisterGear( "insignia_of_ravenholdt", 137049 )
spec:RegisterGear( "mantle_of_the_master_assassin", 144236 )
    spec:RegisterAura( "master_assassins_initiative", {
        id = 235027,
        duration = 5
    } )

    spec:RegisterStateExpr( "mantle_duration", function()
        if stealthed.mantle then return cooldown.global_cooldown.remains + buff.master_assassins_initiative.duration
        elseif buff.master_assassins_initiative.up then return buff.master_assassins_initiative.remains end
        return 0
    end )


spec:RegisterGear( "shadow_satyrs_walk", 137032 )
    spec:RegisterStateExpr( "ssw_refund_offset", function()
        return target.distance
    end )

spec:RegisterGear( "soul_of_the_shadowblade", 150936 )
spec:RegisterGear( "the_dreadlords_deceit", 137021 )
    spec:RegisterAura( "the_dreadlords_deceit", {
        id = 228224,
        duration = 3600,
        max_stack = 20,
        copy = 208693
    } )

spec:RegisterGear( "the_first_of_the_dead", 151818 )
    spec:RegisterAura( "the_first_of_the_dead", {
        id = 248210,
        duration = 2
    } )

spec:RegisterGear( "will_of_valeera", 137069 )
    spec:RegisterAura( "will_of_valeera", {
        id = 208403,
        duration = 5
    } )


-- Tier Sets
spec:RegisterGear( "tier21", 152163, 152165, 152161, 152160, 152162, 152164 )
spec:RegisterGear( "tier20", 147172, 147174, 147170, 147169, 147171, 147173 )
spec:RegisterGear( "tier19", 138332, 138338, 138371, 138326, 138329, 138335 )

-- Tier 30
spec:RegisterGear( "tier30", 202500, 202498, 202497, 202496, 202495 )
-- Shadow Dance is in RogueAssassination.lua, so the 2pc bonus is handled there.

-- DF Tier Set
spec:RegisterGear( "tier29", 200369, 200371, 200372, 200373, 200374 )
spec:RegisterAuras( {
    honed_blades = {
        id = 394894,
        duration = 15,
        max_stack = 7 -- ???
    },
    masterful_finish = {
        id = 395003,
        duration = 3,
        max_stack = 1
    }
})



-- Abilities
spec:RegisterAbilities( {
    -- Stab the target, causing 632 Physical damage. Damage increased by 20% when you are behind your target, and critical strikes apply Find Weakness for 10 sec. Awards 1 combo point.
    backstab = {
        id = 53,
        cast = 0,
        cooldown = 0,
        gcd = "totem",
        school = "physical",

        spend = function () return 35 * ( ( talent.shadow_focus.enabled and ( buff.shadow_dance.up or buff.stealth.up ) ) and 0.8 or 1 ) end,
        spendType = "energy",

        startsCombat = true,
        notalent = "gloomblade",

        handler = function ()
            removeBuff( "honed_blades" )
            applyDebuff( "target", "shadows_grasp", 8 )

            if azerite.perforate.enabled and buff.perforate.up then
                -- We'll assume we're attacking from behind if we've already put up Perforate once.
                addStack( "perforate" )
                gainChargeTime( "shadow_blades", 0.5 )
            end
            gain( ( buff.shadow_blades.up and 2 or 1 ) + ( buff.the_rotten.up and 4 or 0 ), "combo_points" )
            removeBuff( "the_rotten" )
            removeBuff( "symbols_of_death_crit" )
            removeBuff( "perforated_veins" )
        end,
    },

    -- Talent: Finishing move that launches explosive Black Powder at all nearby enemies dealing Physical damage. Deals reduced damage beyond 8 targets. All nearby targets with your Find Weakness suffer an additional 20% damage as Shadow. 1 point : 135 damage 2 points: 271 damage 3 points: 406 damage 4 points: 541 damage 5 points: 676 damage 6 points: 812 damage
    black_powder = {
        id = 319175,
        cast = 0,
        cooldown = 0,
        gcd = "totem",
        school = "physical",

        spend = function () return 35 * ( ( talent.shadow_focus.enabled and ( buff.shadow_dance.up or buff.stealth.up ) ) and 0.8 or 1 ) end,
        spendType = "energy",

        talent = "black_powder",
        startsCombat = true,

        usable = function () return combo_points.current > 0, "requires combo_points" end,
        handler = function ()
            removeBuff( "masterful_finish" )

            if talent.alacrity.enabled and effective_combo_points > 4 then addStack( "alacrity" ) end
            removeBuff( "echoing_reprimand_" .. combo_points.current )

            if buff.finality_black_powder.up then removeBuff( "finality_black_powder" )
            elseif talent.finality.enabled then applyBuff( "finality_black_powder" ) end

            if set_bonus.tier29_2pc > 0 then applyBuff( "honed_blades", nil, effective_combo_points ) end

            spend( combo_points.current, "combo_points" )
            if conduit.deeper_daggers.enabled then applyBuff( "deeper_daggers" ) end
        end,
    },

    -- Stuns the target for 4 sec. Awards 1 combo point.
    cheap_shot = {
        id = 1833,
        cast = 0,
        cooldown = 0,
        gcd = "totem",
        school = "physical",

        spend = function ()
            if buff.shot_in_the_dark.up then return 0 end
            return 40 * ( ( talent.shadow_focus.enabled and ( buff.shadow_dance.up or buff.stealth.up ) ) and 0.8 or 1 ) * ( 1 + conduit.rushed_setup.mod * 0.01 )
        end,
        spendType = "energy",

        startsCombat = true,
        nodebuff = "cheap_shot",

        cycle = function ()
            if talent.prey_on_the_weak.enabled then return "prey_on_the_weak" end
        end,

        usable = function ()
            if boss then return false, "cheap_shot assumed unusable in boss fights" end
            return stealthed.all, "not stealthed"
        end,

        handler = function ()
            applyDebuff( "target", "find_weakness" )

            if talent.prey_on_the_weak.enabled then
                applyDebuff( "target", "prey_on_the_weak" )
            end

            if talent.subterfuge.enabled then
                applyBuff( "subterfuge" )
            end

            applyDebuff( "target", "cheap_shot" )
            removeBuff( "shot_in_the_dark" )

            if buff.sepsis_buff.up then removeBuff( "sepsis_buff" ) end

            gain( buff.shadow_blades.up and 2 or 1, "combo_points" )
            removeBuff( "symbols_of_death_crit" )
        end,
    },

    -- Finishing move that disembowels the target, causing damage per combo point. Targets with Find Weakness suffer an additional 20% damage as Shadow. 1 point : 273 damage 2 points: 546 damage 3 points: 818 damage 4 points: 1,091 damage 5 points: 1,363 damage 6 points: 1,636 damage
    eviscerate = {
        id = 196819,
        cast = 0,
        cooldown = 0,
        gcd = "totem",
        school = "physical",

        spend = function () return 35 * ( ( talent.shadow_focus.enabled and ( buff.shadow_dance.up or buff.stealth.up ) ) and 0.8 or 1 ) end,
        spendType = "energy",

        startsCombat = true,

        usable = function () return combo_points.current > 0 end,
        handler = function ()
            removeBuff( "masterful_finish" )

            if talent.alacrity.enabled and combo_points.current > 4 then
                addStack( "alacrity" )
            end
            removeBuff( "nights_vengeance" )

            if buff.finality_eviscerate.up then removeBuff( "finality_eviscerate" )
            elseif talent.finality.enabled then applyBuff( "finality_eviscerate" ) end

            if set_bonus.tier29_2pc > 0 then applyBuff( "honed_blades", nil, effective_combo_points ) end

            removeBuff( "echoing_reprimand_" .. combo_points.current )
            spend( combo_points.current, "combo_points" )

            if conduit.deeper_daggers.enabled then applyBuff( "deeper_daggers" ) end
        end,
    },

    flagellation = {
        id = function() return talent.flagellation.enabled and 384631 or 323654 end,
        cast = 0,
        cooldown = 90,
        gcd = "spell",

        spend = 0,
        spendType = "energy",

        startsCombat = true,
        texture = 3565724,

        toggle = "essences",

        indicator = function ()
            if settings.cycle and args.cycle_targets == 1 and active_enemies > 1 and target.time_to_die < longest_ttd then
                return "cycle"
            end
        end,

        handler = function ()
            applyBuff( "flagellation" )
            applyDebuff( "target", "flagellation" )
        end,

        copy = { 384631, 323654 }
    },

    -- Talent: Punctures your target with your shadow-infused blade for 760 Shadow damage, bypassing armor. Critical strikes apply Find Weakness for 10 sec. Awards 1 combo point.
    gloomblade = {
        id = 200758,
        cast = 0,
        cooldown = 0,
        gcd = "totem",
        school = "shadow",

        spend = function () return 35 * ( ( talent.shadow_focus.enabled and ( buff.shadow_dance.up or buff.stealth.up ) ) and 0.8 or 1 ) end,
        spendType = "energy",

        talent = "gloomblade",
        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "shadows_grasp", 8 )
            if buff.stealth.up then removeBuff( "stealth" ) end
            gain( ( buff.shadow_blades.up and 2 or 1 ) + ( buff.the_rotten.up and 4 or 0 ), "combo_points" )
            removeBuff( "the_rotten" )
            removeBuff( "symbols_of_death_crit" )
        end,
    },

    -- Talent: Finishing move that creates shadow clones of yourself. You and your shadow clones each perform a piercing attack on all enemies near your target, dealing Physical damage to the primary target and reduced damage to other targets. 1 point : 692 total damage 2 points: 1,383 total damage 3 points: 2,075 total damage 4 points: 2,767 total damage 5 points: 3,458 total damage 6 points: 4,150 total damage Cooldown is reduced by 1 sec for every combo point you spend.
    secret_technique = {
        id = 280719,
        cast = 0,
        cooldown = function () return 45 - min( talent.deeper_stratagem.enabled and 6 or 5, combo_points.current ) end,
        gcd = "totem",
        school = "physical",

        spend = function () return 30 * ( ( talent.shadow_focus.enabled and ( buff.shadow_dance.up or buff.stealth.up ) ) and 0.8 or 1 ) end,
        spendType = "energy",

        talent = "secret_technique",
        startsCombat = true,

        usable = function () return combo_points.current > 0, "requires combo_points" end,
        handler = function ()
            applyBuff( "secret_technique" ) -- fake buff for APL logic.
            if talent.alacrity.enabled and combo_points.current > 4 then addStack( "alacrity" ) end
            removeBuff( "echoing_reprimand_" .. combo_points.current )
            spend( min( talent.deeper_stratagem.enabled and 6 or 5, combo_points.current ), "combo_points" )
        end,
    },

    -- Talent: Draws upon surrounding shadows to empower your weapons, causing your combo point generating abilities to generate 1 additional combo point and deal 50% additional damage as Shadow for 20 sec.
    shadow_blades = {
        id = 121471,
        cast = 0,
        cooldown = function () return ( essence.vision_of_perfection.enabled and 0.87 or 1 ) * 180 end,
        gcd = "off",
        school = "physical",

        talent = "shadow_blades",
        startsCombat = false,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "shadow_blades" )
        end,
    },

    -- Strike the target, dealing 1,118 Physical damage. While Stealthed, you strike through the shadows and appear behind your target up to 25 yds away, dealing 25% additional damage. Awards 3 combo points.
    shadowstrike = {
        id = 185438,
        cast = 0,
        cooldown = 0,
        gcd = "totem",
        school = "physical",

        spend = function () return ( azerite.blade_in_the_shadows.enabled and 38 or 40 ) * ( ( talent.shadow_focus.enabled and ( buff.shadow_dance.up or buff.stealth.up ) ) and 0.8 or 1 ) end,
        spendType = "energy",

        startsCombat = true,
        cycle = function () return talent.find_weakness.enabled and "find_weakness" or nil end,

        usable = function () return stealthed.all or buff.sepsis_buff.up, "requires stealth or sepsis_buff" end,
        handler = function ()
            gain( ( buff.shadow_blades.up and 3 or 2 ) + ( buff.the_rotten.up and 4 or 0 ) + ( buff.premeditation.up and buff.slice_and_dice.up and 2 or 0 ), "combo_points" )
            removeBuff( "honed_blades" )
            removeBuff( "symbols_of_death_crit" )
            removeBuff( "the_rotten" )

            if azerite.blade_in_the_shadows.enabled then addStack( "blade_in_the_shadows" ) end
            if buff.premeditation.up then
                if buff.slice_and_dice.up then
                    if buff.slice_and_dice.remains < 10 then buff.slice_and_dice.expires = query_time + 10 end
                else
                    applyBuff( "slice_and_dice", 10 )
                end
                removeBuff( "premeditation" )
            end

            if conduit.perforated_veins.enabled then
                addStack( "perforated_veins" )
            end

            removeBuff( "sepsis_buff" )

            applyDebuff( "target", "find_weakness" )
        end,
    },

    -- Talent: Attack with your off-hand, dealing 386 Physical damage, dispelling all enrage effects and applying a concentrated form of your Crippling Poison, reducing movement speed by 70% for 5 sec. Awards 1 combo point.
    shiv = {
        id = 5938,
        cast = 0,
        charges = function()
            if talent.lightweight_shiv.enabled then return 2 end
        end,
        cooldown = 25,
        recharge = function()
            if talent.lightweight_shiv.enabled then return 25 end
        end,
        gcd = "totem",
        school = "physical",

        spend = function () return ( talent.tiny_toxic_blade.enabled or legendary.tiny_toxic_blade.enabled ) and 0 or 20 end,
        spendType = "energy",

        talent = "shiv",
        startsCombat = true,

        cp_gain = function () return 1 + ( buff.shadow_blades.up and 1 or 0 ) + ( buff.broadside.up and 1 or 0 ) end,

        handler = function ()
            gain( action.shiv.cp_gain, "combo_points" )
            removeDebuff( "target", "dispellable_enrage" )
            if talent.improved_shiv.enabled then applyDebuff( "target", "shiv" ) end
        end,
    },

    -- Sprays shurikens at all enemies within 13 yards, dealing 369 Physical damage. Deals reduced damage beyond 8 targets. Critical strikes with Shuriken Storm apply Find Weakness for 10 sec. Awards 1 combo point per target hit.
    shuriken_storm = {
        id = 197835,
        cast = 0,
        cooldown = 0,
        gcd = "totem",
        school = "physical",

        spend = function () return 35 * ( ( talent.shadow_focus.enabled and ( buff.shadow_dance.up or buff.stealth.up ) ) and 0.8 or 1 ) end,
        spendType = "energy",

        startsCombat = true,

        handler = function ()
            removeBuff( "honed_blades" )
            removeBuff( "symbols_of_death_crit" )

            if buff.silent_storm.up then
                applyDebuff( "target", "find_weakness" )
                active_dot.find_weakness = active_enemies
                removeBuff( "silent_storm" )
            end

            gain( active_enemies + ( buff.shadow_blades.up and 1 or 0 ), "combo_points" )
        end,
    },

    -- Talent: Focus intently, then release a Shuriken Storm every sec for the next 4 sec.
    shuriken_tornado = {
        id = 277925,
        cast = 0,
        cooldown = 60,
        gcd = "totem",
        school = "physical",

        spend = function () return 60 * ( ( talent.shadow_focus.enabled and ( buff.shadow_dance.up or buff.stealth.up ) ) and 0.8 or 1 ) end,
        spendType = "energy",

        talent = "shuriken_tornado",
        startsCombat = true,

        handler = function ()
            applyBuff( "shuriken_tornado" )

            local moment = buff.shuriken_tornado.expires
            while( moment > query_time ) do
                state:QueueAuraEvent( "shuriken_tornado", class.abilities.shuriken_storm.handler, moment, "AURA_PERIODIC" )
                moment = moment - 1
            end
        end,
    },

    -- Throws a shuriken at an enemy target for 230 Physical damage. Awards 1 combo point.
    shuriken_toss = {
        id = 114014,
        cast = 0,
        cooldown = 0,
        gcd = "totem",
        school = "physical",

        spend = function () return 40 * ( ( talent.shadow_focus.enabled and ( buff.shadow_dance.up or buff.stealth.up ) ) and 0.8 or 1 ) end,
        spendType = "energy",

        startsCombat = true,

        handler = function ()
            gain( active_enemies + ( buff.shadow_blades.up and 1 or 0 ), "combo_points" )
            removeBuff( "symbols_of_death_crit" )
        end,
    },

    -- Invoke ancient symbols of power, generating 40 Energy and increasing damage done by 10% for 10 sec.
    symbols_of_death = {
        id = 212283,
        cast = 0,
        charges = 1,
        cooldown = 30,
        recharge = 30,
        gcd = "off",
        school = "physical",

        startsCombat = false,

        handler = function ()
            applyBuff( "symbols_of_death" )
            -- applyBuff( "symbols_of_death_crit" )

            if legendary.the_rotten.enabled then applyBuff( "the_rotten" ) end
        end,
    }
} )


spec:RegisterOptions( {
    enabled = true,

    aoe = 2,

    nameplates = true,
    nameplateRange = 8,

    damage = true,
    damageExpiration = 6,

    potion = "phantom_fire",

    package = "Subtlety",
} )



spec:RegisterSetting( "mfd_points", 3, {
    name = "|T236340:0|t Marked for Death Combo Points",
    desc = "The addon will only recommend |T236364:0|t Marked for Death when you have the specified number of combo points or fewer.",
    type = "range",
    min = 0,
    max = 5,
    step = 1,
    width = "full"
} )


spec:RegisterSetting( "priority_rotation", false, {
    name = "Use Priority Rotation (Funnel Damage)",
    desc = "If checked, the default priority will recommend building combo points with |T1375677:0|t Shuriken Storm and spending on single-target finishers.",
    type = "toggle",
    width = "full"
})

spec:RegisterStateExpr( "priority_rotation", function ()
    return settings.priority_rotation
end )

spec:RegisterVariable( "priority_rotation", function ()
    return settings.priority_rotation
end)


spec:RegisterSetting( "solo_vanish", true, {
    name = "Allow |T132331:0|t Vanish when Solo",
    desc = "If unchecked, the addon will not recommend |T132331:0|t Vanish when you are alone (to avoid resetting combat).",
    type = "toggle",
    width = "full"
} )


spec:RegisterSetting( "allow_shadowmeld", nil, {
    name = "Allow |T132089:0|t Shadowmeld",
    desc = "If checked, |T132089:0|t Shadowmeld can be recommended for Night Elves when its conditions are met.  Your stealth-based abilities can be used in Shadowmeld, even if your action bar does not change.  " ..
        "Shadowmeld can only be recommended in boss fights or when you are in a group (to avoid resetting combat).",
    type = "toggle",
    width = "full",
    get = function () return not Hekili.DB.profile.specs[ 261 ].abilities.shadowmeld.disabled end,
    set = function ( _, val )
        Hekili.DB.profile.specs[ 261 ].abilities.shadowmeld.disabled = not val
    end,
} )


spec:RegisterPack( "Subtlety", 20230512, [[Hekili:n3ZAVTTvY(BXOaksX2Q6Pt6clbKwJU3MDB3GQ02VzkArklUHIuLKkoEHH(TFN58IN3KYpslUa9glE4HZmN59mNzVE41F86frHvXx)lJgmA8GPdh1F4ObVD84RxuD)U4RxSlC1NcVf(hzHBH)7I93uLgxDp(G7tZdJWnOmFFXk4HxV4M9jPv)u213yFxhcRDx8k4NVa(NBsIIIPRnUC11lW1E(GPNpC0)4WYdlhoO)Wdl3Vd3OY(hE)H3txW4Zh(D8fmO)B4lrzfJElzf)NDvjBt(FXhwgVEDYQK4Sv3lTUjWxJSUFo)ZWA2veVkF7nHvhw(U0xDBC1MWIdl)W()3)lfE63N)LdlVjEDEb8hlQIdtR20)6fPjLvLeIa9NIrkYVqORXzH3Kc)93F9IWvvj5zWI2egLFxzvrYNIPODrYo6JwWF)dl)18Qq8hrq7Nwl(AF7NdZsk3Cyzicc73Dg8FkrGrAtpSSkhbZS41jaESUiFl8tBqSlSSmbrZBYZ2xcBsg8L(Xe8)(hXHFklUSe2W4phdF2e4JExm7dH0JTHaY)dF4WYU7ZsHvIF5KSBbkxiG3av6DLL4(N176fakb)us41l6cFS9Rx3NrA6VF3HLp8a7hPid536DyzhyRpSeyostdQclaIFz)Yn7ruklOSkVaqJlpSCcDd(CiS)aTT)UIKC4ZDFqHGK176kG)sJ(NVdO9Xv1he8Da)xP7JroxaMIcZkJd2gUk8MIyaSbEFYNDkhar(J8GD5jza8ffJ8ua1z2HLJOaMZNpwcljFkGzBBCucfQfugGnngGWphhiVtey4nTNobFV3s3VQW04SQ(PWzfCKKDBaLbSpJ0GulvUWFNrxO8r)Z0CamsdJG)(BbraGEaeLBaMJniBcsUHtK8ccfIaXaFgdKVlPAdrMcrt2zdHNJ(UeEs5xb46G3klVcxwY2q4PBqemICyfqv)CRaGacugq(qGgoVhRDExZdkyvS9Qe6jLfnbjuuki50aEWjhwgftE6Aqmj4oMusFaLctYkjRHrGt2URa0HefOEwutN1zoONsd5FhqookauTeq4aj)Q)ZyklxnaOY5YPes6DKFDKIn5jqX6AfMru0pqFcfQ75ICmQ(8aypqz6Q4m(PrZ88JRX3AqhX1PpbC1h9TgCTR4qGsnd7JQH9BysziKFrZqUlvgZHDD1oaM(sa85ZIqlufjRQqJtIV1QqaUO)raAjJApJjSbC9GgAemEJgyOOY4htOwLIdlstqBbuj)fmSe1KuKbADqtw999PLGVA8KkDYPySTIZtyxDlJEAftERpm5DPLauwgUMP(BndZqlGtoLAaKICXFbG807jQ)4hRGCXc4RblhO(57Rktq1MCBF9oAm3ptdE8cF8ZfCOLW3jyn6iKm3zRytM4Gy9DT5yhjoP53Hh8AwaqViUpFpZnckyIGvcWtC1cWzJflOgpwaGo4lc6W4XsKCZba6wpLOQYn9rYczuC8U4cG4wewbU7U16IkJxvexzBr9CqbhoWHJGskOujR)gQkv2UlsG0n8UknVKXJUjPQI4jgXfTp87ihhUAdzia9aL1a(hf85yW8fxlfYamTnAPqfSikP7B7lX3XQYWH6E1jjRWDEgoJ2vMu2UVZehoMJFl3EuOSTu8AmHxZHHlQ1spo9zzdFd3Xa)E66X((qDd8TjeeJajkIxxeJs5QbkW8KdxrCw5Eu8gdxyviYBgwuakgbVHagxWlU17trH7)aL7XxG44xw8xaX0f5xr1sSlhIDaXsz6SFFVyI4uhjYtb4oRF59GYG0YG81brXHGs36vdl(TeAAd7Al2nc1L4sHDsAnnVc()a0yD4(0kBrfQq8)1ygtSkjb4FYaQ2N3NMfxq9mhcUBBsCjvrknIvzwb6UylkiLV3pbkJlk2VRI6hphTPNQGY387aoZKTBjkxsWft)ccx7HWJLcO6tjR(KnpXBzKxLPjRIdaUQGi4Fyx0WQnqvxC0vLYysJIbWhWKyIcuGdSOgHr8jKeRmXuugWsEti5nrYc)tlhesjaLkrFOlQ5fN57sszakfeaiajEhr0o1samZoXR2KJXUvedkb2c0OA)7vW3FytmQOfr4Y4ykBKK0gj89eEOxyG(4r)AIq6InFeJvlFvpAyyVtbIyhuQooicFHC(zaJbJehIgV3iFV3y3V3yFV3e3V3eFV3u49SfKqZmU2DPs3NYvRY3NjyVq6CrmDlHtIe0FXBa1Lj3MLxqe1abVZXJkzMc06E1QnCzEYb4G(tlP5SkgmPGVziQ1am8uLGUtjosLz6CaYwI0Oz0xfPBpxl5WWP7O6hFo9YFUicyGicbgaHExfSlDFz)je94a9XWiQtzU2qH8geet27hUQK6r86KIYQwgN1QOsBHMiuOROAuN9A3ommKf4AywLVI(pLIzbveGKS4VSlPiMPaxWir1o8p)HRO(AkYcdiw06OrUuvrSuEvu1RlBO92vr9joT2bjx3cNEINcNTxyC0ZJvPPat(19zuVoa6sjGPu5gHRhwZZAxugmkNigvMFgLCbsSRWxDhyPGAfCnH0SH(h4j9NdtsrOONuGTf7ZArGl1EScSgkSd1js2waenlxoAkXBuMy4NtUnVOw071GuZa5NVLKax0jhMxmEwlDfbRZxTxBzkFYW0qepV32oHR81TihMSWB1tpPSj91C75mFwi5cx4dfrse5NXssefxuQybNUQGQnO3TGFawdSrvah88bcOVqK57qbRe(X4acQBNYFqTYcoTD794FW)qhBaU0Dqn0wH(mt8WcJuat)Ir4todNhKkt2UFlL(jfRP43vZBlHVJUyUwNWBrb5k58Jah66jf54ZjsRsNHQMi3PLVolb2ICJuOI8YsB6NQZDBRaOXT1z2UnNtNET)Z6kTogX2AMaIqHCZZbJ9Zc3mbE8gzBybeak6kqrbq80qR)D(DXidjpoAQNuHySP5C)KF3h(3yTZwfsuLGWh5FwsOhGbsFycsWhsvdYEur8TXzMblYGYD7tl1cw8xgEH8ctrEUYG)7(OB3sWh11(g51Et4TOkCuKbt9JwiOIcBkccvamO7dittj(xkFaDTf0tHWuADrb4hllAWn5FrA3S8qEiH6HNQ(XCDKUnS4t8QmGXGlHlbLXyqya2c0xl(V7Y9P6JqwYnOgpTTVuQhLXZBrDvs(IkF33lm)4ndsJ0YwzD(bnl2Gr18Q9BAgXXjrnwnYfhPAR2oDB2TIteWMhp7XV8je8OjFU5PgZW79X1EVts9QDV7hY1eYveb)2fdmDyGq(bz5T0QqgJofYlHTwSX6X9Ylxj6KrE2RiAd2v)bXKgq0hscSlPsjfbemnytCkCcylRiwSOP8k2YtSfXKwVnsPrTIgWHf(5wXd4ipMnMU1601vZijzXvHdQbdLWoz4CglxoYNb0DwntnUZGmh1y(4gfMXsdLisgh1GY(dvCvyC)PxVamKaQOxhaH9Ouco5pOntXxHpansT(C4vRBbfc3ljmt5ATTGsJO99Xh5fEd0SrZDqF)mJVSiQw(u1q2U)gtSmmf81icLt3jzn(oIpO5FI3Ulhw(Jyyi949adDZFwPtUmkr7CfJgNG6)mlnpYjsNMU0ROvj)NP1iM6QCyu4FUh0k5SOnwRR8CEMWCvb9UYzXMwZQkqPDwYFUpw1yX4b6YKgRV2ZtFwzxbFUGBaLvgjLmh1)(94tOzu1sNIqCWKKZHDPH3tuQUGagWrdho0KvBeATM8GP2Y0fhfwNgElO3jKHqMQwvY7RRVanLuevx952UIsIPQTga779RapJy62q5JMYS0hGtsgBLGpf0)EoP4j8sTFfXbDuOrIywSplJsm)rW4e6dfAStlIkrO9AY1YeYt8MbGAkiMOeWRaw7a6lLwAFnB69KrwwPIO4gQjyt4NJ1IerKyFQmTiPnijcc8ePc0yu)V7rvb3IVh4()99pISCjc7J)rjoCnqnKmBSjUkPKOpg4lq26d1pegJ1qUKD9HHmdR(5LyhvwKsd4j)KaYV0(QUmL7(LlvqU8uWw27oArnTOUClYHp9cj2osTHTMwTwAK63uT1Ou3SUHRRi8FmBnzx1R2xtr3uElnjJve9F7KyZjoBI)dISlLbxXuNcJQO1kDxYtrbtoXfdgtLbZaa46xaP3qbIyCX4bbJ2TYiFd6ov1eRF7yy7AJrQvUl2tReWkFc58jpCGVvAPFIQz0TMCq3rOcQDIdaFFwme9gYqFVCaOHjrbKcX1pmkQuQHbSXnFPlHa(5NCgLBqMrnfz6bnH9CmcqhK604YSKDCvU5zcVAszPv5JF8Q(hwsepOAPJO2XxZ6p4QnyVbGHzjGduxmHxVSoJ8cL1Hz3JlVV1ex6M2BGgyTZPOYDjivHqjTu(JXdk5Tt9pV(kQOnn7FMGKNtqCxNtDR6CWaS2tJ2xe2cfAkL02w(6EIkmh5xH5aotyuEfRDAGvT6tKZt1(TG(qfvoV10HsYI0Ly9LA1rdmcpIecCP10)9ePgJ5ORVwTPzRIiCprPBXiocLHLMnyvAOAbru7fCJyovPGo69uPSNBKrM60oE8EF9huFk)XZef8skMSiq2NlOimDX8cfDrJ0INT6eXU5lRkIvIS5i6LkBPoycxHU7wR1RXYoo012SptJ18L2M1qphsIC(E8PVWJO2BvQV3(BGTB9(BT2b5sPPaHfDF7v8nPXMOsPWiUzf6P4mjO1UScTMghkzR0AM4hmWMJfg6bBblZm(L3qr1NmOW8tpynRdPWUVGS)9FZujwD9tMEYiVkNMejAstuGwb(mfkU2dlmgDjzs(1(rzfLqspNWG42nFcyqswqkelwFs)W0GvH6uv4vVHMgvQvdPgdsvWM9y1Y6nqbP2Lt()JPoupKb90Mzcss5Ffr2G17lUNSvn0cT(3Q4IY4c0AmzRCNrZM3kisLyAoBWDQP0c6BNq(wSTOtdWQ)r2oxzp7g40ohvRfG(ZFt895yJ7PN0qwn)SUwfTEMAI58aSw6ok82BbsMn7QQlW048jMUWjTlX)5(KD7Wwogf1ascSjqauC3fQz20ESsyjJgWliJlR1G58Kvb3wKeVg2OvBCrRmxxZ0PVQiOR8UHOdaOB17CUROnolgdrA6nKmFsYc2(sClWsUaVZ)Gh0b1fK6SaFy5veUu)KHg05aY8KcMi3jfpQcN4nbpggogqmCy03n0xsyzwT1TfTIsDBTEy5)hPmqhw(7w6)0YnrQ9)YJQKGU6CIg9dt0722D0Z2(2XzAkSu2hfuZTQTUTWr7wGpZKUHNNiNqezISVarKsWxt5YGLYrvDz2tTcUg722rRPYg3z3g3A76kwbzv8WsnrCLQAAMR2gJy9P6feXiPyH3qIWgtkgPgROkgwDVyqu)dl)pzPI8BRFDeinJx9MuGTai8xUt7niXf3pJqAItxdO0xaRxbHBXE196ftg4jP2UVnHYzfEc1bu7oN(u4tmU0kir2wDnAw(1so30REZhou3IpLSZ2y8YaqlSal)KSZkHgBslOdclW)mI(iQ(5b0S(mKHESsaPRvQPgVTvTxVXg16S8pxQpSgrKsASgjmx59LbHw5P(eBPBw0sJY3ybc5CdW)Qskl5ciIcPvkk5zfpC98c1nGcr4gTNqOSWDO10C2QTZl8PYS21DCTLasVn63Rs9e3ODE6A5KIH2kBH1iJ1CHHY8hTNjUiCpPGOUIwdlM0LE69v0nOkP2rlV628pWtowumL0fJtDKmz1UPeDwCnnw9us9LtaQfLLgzW(ooo2Co3gR8HDLQmPqhBzbXa)MktibNA2BvTqqwdBDFeWI4KSE9QSO2EYolzLB(VVFFb3sAPWuknTEAThbyievShXEkTCR0UE6MyrXLjjnpzBSJC8zJr10P6wqv0YGSlUjmb14nyBpCwlYqDJkAVuC(4JExj6y2hLd)mqxnjLYWEJ3NIPwBqBGReDS)p2KGHaXAf9pi)vodVwc5jrORuL0ouZ82HqnsOz(gDIQKeEhDgYqhXd4qH5lRIX7jiX6))6EavZKvQtrYaJRf3XhqHZuykIP3A)WOKJRg1e05jNgz(CSqXYgvHwlNkjNO4SGj5RDSixOKBq3DUM77GJM0zhXn(LESiuXO2dTwIdWI6aN4v7dggB0t1KO6gvAHAfT4RCKE)gmAEU3u2sG4rkbpzs8o(RA4Jl5VZeHz7tWQT7XJtB7CBYkFkzxaBRSf5cNmWxIQIW)vC8oAZb(R0NxFb3ChgOEe)1gTKGLM9INQ(WwPtXY9kzu)cdHjlbY4hp)v(DVxGM4ew5EMAyWCqyAcoi2SRvrfV4S1RzVf)j(BajfU6rhRS7mEonAddwh5MFpkS4tbGA77uZKrtLd1sqjCkSZ2tCX9zRWKMj1KISujQ3aIIiRyxmF7UaPzfOrNEbLo2ITOTBTsya1iPkDt89LwGmVQh1zNZfEfkZ0qbVEMk4R91emEzAp5ziOA)T7qxEq(QEU2Z0yOcFZpVpTkb0isDWI95pqMjc8wnjLmT9icReNSR7(dm70mH6ZKMXg8We3b2kI3MSI28lUA8OJuPbxfjf2O3eyJit7d(cMZXcbCjciGIJYXcu3antl1t1U7t1J0S9PIuM1IfJQDC3eUAAPBX(DkRRH9m8zosMuDhwTm73CAUUrvPhZqH7MuW9zGJ)Ui6LuzOYf1k(ZjLRIlidLPA0UIgA0NXOJHvrNVNtgabRCxyb2TXLxV4JixrY2D5f8ygELOSlVcpa(Z9aZxegSbzCzTVkFBizYqb2rYij799)BYL7fheO)qEg81ip(vm8s)cq9kQ5ExpMJ5WY6o8l9e7(y77UcvtBRTsr133PVq77BTVVI0GPTNgPhtF)(UVo7N(O1sh1Dm5TA5URptUmaA7JSR6D)W7TWVYgAphh36f6qy9vxR)K(4LxtaCgxQnDSDOdw)hXHJveKMBJJd)Caspz(634AFzEbASNAEh2697jcNo4aR9QsBtn9hRTNYpbq16P9QOYJ7OEOD4QUGSAaLzRzRJQt8k(k8N0U4RX97PLQCFM29HdSV9YjmwBRTLe92UTpbQ8qh20OnHRb6l3zUgBLJtmZ2AvBBD33RT9t8ey)zAQCTXkD8J(oBTDGAERbpn(e4NPrxWiCUK5lj)Z1yFZ8Q6pMbF9lYhZQodPEE5zr3HS7S6mIwsWVoD)LYznh77tu0(RLRApnA6x1D9jFs5sD5JgCTY2tM2dplm81xDFnOYC2oyOKXJNKJ97j54JzVAVxPhE)prit4w8gGASIgBl5)1paEme24(Qn5fxVyrY2Falju(6K6kiu2xmEnoD23kp0ro8EBRG3sGNH5lEMLXkI9xJxOFRpu)YcDMXe)y2WPo2xLm4B7fplz9mPKfH0RV5WYN2i9ualYygSRpldUt5nhhDNKD(5CGzk)b4zhHECQuqOZif4yMTI7SF3dp4lFhZNPCl2qe4fAcy6gxCmCtq2bMWUZHLcdZLt74SHDiec7dtZhEqzTJCT2XMRDSR1oXCTtCTwCqzsOY)1pslDFGyFEyXO1ogwwh7M1Id3o2F15Y)rhBny18rDmvqFjqy6CIihJUy6mzOKfkuhnLYiT(a7II8GFF0t7xYjmPIoovTSav2N0)LYc)D8uC4lzZzYok16E(fkK)5ZMq1y)xYSJuMkOn9izQm5F3ZOtfpQbh1Ez)9FZ3W7rwQdkGuPag5)pOp0RvULKuxcbvq3cxcdgVeJFZCZ0nLCKdQrpwo0hqCmqy00tzcKkt7YxpAa)3DoLlLwdZzrLzBXRR3A9PAj(MJM(6U(nrnPhvg85z6r2SuRuuBk8kQ9H8LZQloJonLaV)LmniBg7OzTubXeiIdnUkojOAQRMAm8uZ7BWdpGxmevTgWk704hCCtUT0DY56X91R5TDcxU6WJy6m2mPLSHpcoLNJ5QOm0PoehnbO5Gx6NkpHfT8YKzRO8VRnkfLFKYKtK53(3RRjQpH6G2OuoknSrnF2Ot7AeLh16KRP238zxaSAKwrZCA91RgEo8vzi2zIYQQGLhVCmTVN0KZqp8WjDBY5LoDnJXfD75HhS4o0WEDOiWLxmONjext5vuqid6MVeFc555vyAY5rbj2cqxRbDsFoPWPvw75Wo(0xmBiq)yK4AfunOJzyTYIN35hNowlNHLZKUyIuLZNyRq2mN10VmfoFGq374(tjO1FVMuCgueTwjWKQ8uX)NLrnNj7lX0kh8ImB025JvCz(sic0Un2p)G5Wb18V6RI7C0ZZiIthLQR)gHx0bmOfhWu9DroDVNP0itAoGOKxd9DTJz3OmF4ac6)8mG30bBLRT2z8BbhfKfo8A)(m15epEexRy5R2aAZuNJkC3yOIGxBuGaS1oOJZdmx9ceiz6TThbxs609epvhOZj2VtNeNmnU5jKFP5KFnTNH4ODRlgKpsz)AjRRKBx2yHNn8IAgI)QMlAnQbgq1UE7QBq3Q0zKzFHdAWSDTJL8Ax3EVlUmR8jOEu5tsRw87HbVyJlIRPD4axRGWaROoIQ49VrZ5l9ZqJS1ZMQAZg2FQnTWMJXaWJsd(1lTXAJhUYzsXb)VCCK1KVxG5lwJKclOBs28Xdo318gRfyKd)6OtiLJwxXi76kg0PR5mftIPvDEID5S3k75a(OE2dkF0aDW3iwKJgfg3PR7M60VU5lNnbcBHc3MndrVoDT5vCnQQ46fLt7PosUAJfuhuh76n10Oq8f0U1NgmJnPxBGnpQM7Oj863O54o(St7n4g3HZyHJ8TIKkAmsT0)is3QhIHQg7jzsgMCDS0J5eG6DfQtxJKOmyGQvhjH3M88ySSPi)dcly36)MPDSr36Xrclx8G5ZMyhpAaWaHiBVL2Ht3lETpW3GJKodOeHgPn4QSQscd6XPKJI8VyevjRhu5r15ECGbOvpxPQdS0YOXs)TeJqQJ5TetlQJ5Lix9yXGH6yEt1EaW2KGYs(gu1fqj0gZbkjvTkpc0mFIPFeWQDoiKa18TTHSMpY80tff1hGtnJEV0q73inspEsdHjxiEPjwzvCcnWlvxI)UCjORrlAHjmYcOTRalltGmoqRxqCVQ5UCAJFw9RkMstwOz9QRZ09quNA1NKhNT(tMnQNfq3SSVNi54Lj9ZpX5Io(Y5O9ceRWR1rPnEAb06hyB79L8YH12jTdLn6xGC24mDtYB8VN70smaxwp10y4KUHxYmBhH1BmOx7mOn9wwUxYn4NWiQUThXfj2cLGJ2OVB1CUYuKhEWDKe9SeP05fIEuqHzK0rzT5ob7hkTdKugel3pyhSWc(JrTNhF2Wgyb60vOVHDhpebszjQOh)D31cbsnzX1KinvPDA4Y8AtLH2c9V)IeevdqsEgAEdEN7u09CgB(xLRQQhwolzRXbl4jULtAsI2Ach6o61YH40R9ItFfUTSpkH0wBm40Hd8KrBrif2QlHq9tJV)P2Cfr(wLQBn37Hk1Hd1BdR1ih9Rebzfm1yybqRVGRmNlB3m0SENK61gtlIYJhlrN51o9KZNHda0tT0d7T7BRpnJuQ9SwpU4VkYQ9lZL8Eovzp6yn14UHuEzg7A13YMZ9GKwcfIS984nuYRiRznF2fs1NuEfp8GEAdgpOoVbQZlZE90RK3FtM)LUogCwDq55G5SjdO5AEL0OY01owkqy8D4LBBYGoMzE64obP990xLbrz7eV0hZzw67wWtN6YI9vE(n(SHesThxtvyDE3jNp61nuw5E(8dUb77t8toB10C8jryAKeyTR(OPqHY41UHaPFXR6ur3vresgGR9Gu(D8h)h6Qu)rN7j14YhEkcT9eEOR85ASXqUC235p0Ulr3bS68VLIM7Ou6AdXrsR21aJwZEnnF4aZc)Q2uKVyZDX2YE4M7q1OwJiRuf4KpEp2yUVeiSEizYUFP2C90QSYEeZ7b5YvtBPlfRR082LbkVQ49AcHyVlec(dL2i(QWYeOQH0ZO3kO6(LpK3(uBd)c7(dXnEZs74pZk897klX9pRNXruCK4aIcIe5xQ8iDf1CVm3kW644x4yI3KkWAtmMdRekY)u0uKhw(TahkRDh52ByQkrDsw6(kIXgw2(yhm02kL2t)i1vvZR4kEq6GsUiqKDAJQc46U30EcmTKQYlNAVwwyPSS(7J5fH1mdM2B)6lFtthiyXQzsk6D6Rtwc5nqrQ1gnGPbpb)e0xH48DumpXnrb3XyJfzeKbqjB3va2zIcu)K19NRMVlD0Jc7jfWLmo7O1CTIVD1GIMZUCRcxPbBo2HBRDhSvO2gTOJtgxae9dpJSdpVmxpcLR(bMjKK4I6wq0WpuLgl4rbDSO718xuR5cQ9dDebaFxAj6vF4AMMT1s3vf(9rJcZXFbacmOPANaH4O6UiKCHUljHiPCfu67quT1iudoxy4HyBV2hY3hhSvSkm0rJwSUpFpZKf97GMsrxhUAbyyBXcQ69fX4vP8hjP94jHRoIvqCbieizTBCAJ6PAxh1Mst9QD3x2Ufc(6gUKUqsBsy54KyS(d)UzRo7wve1AG(fWGviSP(fsBHoJxGTx3JI6QOs7vk)B6K2AtspfDwUPuTSCGZN9gFz4LLtFdx5ejwvpNhepqWveNvsYDl6W2kS9dxfwuas9GjVcYvmcVqNW7)hO0G4UCstelXHB5lNVdvA6uBFMDjnWzJEwF5W32X7U04o0mKsgwFx))d]] )