ESX.RegisterServerCallback('lb_revivenpc:checkMoney', function(source, cb, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    local cashMoney = xPlayer.getMoney()
    local bankMoney = xPlayer.getAccount('bank').money

    if (cashMoney >= price) or (Config.allowBankPayment and bankMoney >= price) then
        if (Config.allowBankPayment and bankMoney >= price) then
            account = 'bank'
        else
            account = 'money'
        end
        cb({hasEnoughMoney = true, account = account})
    else
        if (bankMoney >= price) and not Config.allowBankPayment then
            TriggerClientEvent('ox_lib:notify', source, {desription = Translate('ped_onlyCash')})
        end
        cb({hasEnoughMoney = false})
    end
end)

RegisterServerEvent('lb_revivenpc:payment')
AddEventHandler('lb_revivenpc:payment', function(account, event)
    local xPlayer = ESX.GetPlayerFromId(source)
    if event == 'revive' then
        xPlayer.removeAccountMoney(account, Config.revivePrice)
    elseif event == 'heal' then
        xPlayer.removeAccountMoney(account, Config.healPrice)
    end
end)