#varibale declaration:
write-host "varibale declaration"
$RG1 = "cmaz-71395928-mod2-rg-01"
$Location1 = "East US"
$VNetName1 = "cmaz-71395928-mod2-vnet-01"
$FESubName1 = "frontend-01"
$VNetPrefix1 = "10.2.0.0/16"
$FESubPrefix1 = "10.2.0.0/24"
$GWSubPrefix1 = "10.2.255.0/27"
$GWName1 = "cmaz-71395928-mod2-vpng-01"
$GWIPName1 = "cmaz-71395928-mod2-pip-01"
$GWIPconfName1 = "gwipconf1"
$Connection14 = "cmaz-71395928-mod2-vcn-01"

$RG4 = "cmaz-71395928-mod2-rg-02"
$Location4 = "West US"
$VnetName4 = "cmaz-71395928-mod2-vnet-02"
$FESubName4 = "frontend-02"
$VnetPrefix4 = "10.24.0.0/16"
$FESubPrefix4 = "10.24.0.0/24"
$GWSubPrefix4 = "10.24.255.0/27"
$GWName4 = "cmaz-71395928-mod2-vpng-02"
$GWIPName4 = "cmaz-71395928-mod2-pip-02"
$GWIPconfName4 = "gwipconf4"
$Connection41 = "cmaz-71395928-mod2-vcn-02"
write-host "---varibale declaration completed---"

#create resource group:
write-host "create resource group"
New-AzResourceGroup -Name $RG1 -Location $Location1 -Tag @{Creator="abc@gef.com"}
New-AzResourceGroup -Name $RG4 -Location $Location4 -Tag @{Creator="abc@gef.com"}
write-host "--create resource group completed--"

#subnet config for default & GatewaySubnet:
write-host "Subnet config update"
$fesub1 = New-AzVirtualNetworkSubnetConfig -Name $FESubName1 -AddressPrefix $FESubPrefix1
$gwsub1 = New-AzVirtualNetworkSubnetConfig -Name "GatewaySubnet" -AddressPrefix $GWSubPrefix1

$fesub4 = New-AzVirtualNetworkSubnetConfig -Name $FESubName4 -AddressPrefix $FESubPrefix4
$gwsub4 = New-AzVirtualNetworkSubnetConfig -Name "GatewaySubnet" -AddressPrefix $GWSubPrefix4
write-host "--Subnet config update completed--"

write-host "Vnet creation"
#Vnet creation
New-AzVirtualNetwork -Name $VNetName1 -ResourceGroupName $RG1 -Location $Location1 -AddressPrefix $VNetPrefix1 -Subnet $fesub1,$gwsub1 -Tag @{Creator="abc@gef.com"}

New-AzVirtualNetwork -Name $VnetName4 -ResourceGroupName $RG4 -Location $Location4 -AddressPrefix $VnetPrefix4 -Subnet $fesub4,$gwsub4 -Tag @{Creator="abc@gef.com"}
write-host "--Vnet creation completed--"

write-host "Request public ip"
#Request a public IP address for gateway
$gwpip1 = New-AzPublicIpAddress -Name $GWIPName1 -ResourceGroupName $RG1 -Location $Location1 -AllocationMethod Static -Sku Standard -Tag @{Creator="abc@gef.com"}

$gwpip4 = New-AzPublicIpAddress -Name $GWIPName4 -ResourceGroupName $RG4 -Location $Location4 -AllocationMethod Static -Sku Standard -Tag @{Creator="abc@gef.com"}
write-host "--Request public ip completed--"

write-host "Gateway config update"
#Gateway config for VNet1GW
$vnet1 = Get-AzVirtualNetwork -Name $VNetName1 -ResourceGroupName $RG1
$subnet1 = Get-AzVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $vnet1
$gwipconf1 = New-AzVirtualNetworkGatewayIpConfig -Name $GWIPconfName1 -Subnet $subnet1 -PublicIpAddress $gwpip1

$vnet4 = Get-AzVirtualNetwork -Name $VnetName4 -ResourceGroupName $RG4
$subnet4 = Get-AzVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $vnet4
$gwipconf4 = New-AzVirtualNetworkGatewayIpConfig -Name $GWIPconfName4 -Subnet $subnet4 -PublicIpAddress $gwpip4
write-host "--Gateway config update completed--"

write-host "Gateway creation 1"
#Create the gateway for TestVNet1
New-AzVirtualNetworkGateway -Name $GWName1 -ResourceGroupName $RG1 -Location $Location1 -IpConfigurations $gwipconf1 -GatewayType Vpn -VpnType RouteBased -GatewaySku VpnGw2 -VpnGatewayGeneration "Generation2" -Tag @{Creator="abc@gef.com"}
write-host "--Gateway creation 1 completed--"

write-host "Gateway creation 2"
New-AzVirtualNetworkGateway -Name $GWName4 -ResourceGroupName $RG4 -Location $Location4 -IpConfigurations $gwipconf4 -GatewayType Vpn -VpnType RouteBased -GatewaySku VpnGw2 -VpnGatewayGeneration "Generation2" -Tag @{Creator="abc@gef.com"}
write-host "--Gateway creation 2 completed--"

write-host "Get gateway detail"
#Get both virtual network gateways
$vnet1gw = Get-AzVirtualNetworkGateway -Name $GWName1 -ResourceGroupName $RG1
$vnet4gw = Get-AzVirtualNetworkGateway -Name $GWName4 -ResourceGroupName $RG4
write-host "--Get gateway details completed--"

write-host "Create connection from 1 to 2"
#Create the TestVNet1 to TestVNet4 connection
New-AzVirtualNetworkGatewayConnection -Name $Connection14 -ResourceGroupName $RG1 -VirtualNetworkGateway1 $vnet1gw -VirtualNetworkGateway2 $vnet4gw -Location $Location1 -ConnectionType Vnet2Vnet -SharedKey 'AzureA1b2C3' -Tag @{Creator="abc@gef.com"}
write-host "--Create connection from 1 to 2 completed--"

write-host "Create connection from 2 to 1"
#Create the TestVNet4 to TestVNet1 connection
New-AzVirtualNetworkGatewayConnection -Name $Connection41 -ResourceGroupName $RG4 -VirtualNetworkGateway1 $vnet4gw -VirtualNetworkGateway2 $vnet1gw -Location $Location4 -ConnectionType Vnet2Vnet -SharedKey 'AzureA1b2C3' -Tag @{Creator="abc@gef.com"}
write-host "--Create connection from 2 to 1 completed--"

write-host "Test Results"
#Test connection:
Get-AzVirtualNetworkGatewayConnection -Name $Connection14 -ResourceGroupName $RG1
Get-AzVirtualNetworkGatewayConnection -Name $Connection41 -ResourceGroupName $RG4
