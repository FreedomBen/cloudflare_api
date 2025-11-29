# Full API Implementation Progress

This log tracks manual, hand-written implementations of the Cloudflare API
operations described in `FULL_API_IMPLEMENTATION_PLAN.md`. Modules are grouped
roughly by the OpenAPI tag they represent.

## Completed Modules

| Module | Endpoints Covered | Notes |
| --- | --- | --- |
| `CloudflareApi.DnsRecords` | `GET/POST/PUT/DELETE /zones/:zone/dns_records` plus helpers | Legacy handwritten module, aligned with OpenAPI spec. |
| `CloudflareApi.Zones` | `GET/POST/DELETE/PATCH /zones` + activation check + purge cache | Zone CRUD helpers plus cache/activation utilities. |
| `CloudflareApi.Accounts` | `GET /accounts`, `GET /accounts/:id` | Newly created manual module mirroring the spec section. |
| `CloudflareApi.WorkerRoutes` | `GET/POST/PUT/DELETE /zones/:zone/workers/routes` | Covers list/create/get/update/delete for worker routes. |
| `CloudflareApi.AiGatewayDatasets` | `GET/POST/PUT/DELETE /accounts/:account_id/ai-gateway/gateways/:gateway_id/datasets` | Dataset CRUD for AI Gateway. |
| `CloudflareApi.AiGatewayDynamicRoutes` | `GET/POST/PATCH/DELETE /accounts/:account_id/ai-gateway/gateways/:gateway_id/routes` plus deployments & versions | Covers route management, deployments, and versioning APIs. |
| `CloudflareApi.AiGatewayEvaluations` | Account-level evaluation types and gateway evaluation CRUD | Wraps `/evaluations` and `/evaluation-types` endpoints. |
| `CloudflareApi.AiGatewayGateways` | `GET/POST/PUT/DELETE /accounts/:account_id/ai-gateway/gateways` and provider URLs | Manages gateway definitions and provider URLs. |
| `CloudflareApi.AiGatewayLogs` | `/logs` list/delete/get/update plus request/response fetchers | Covers log management endpoints. |
| `CloudflareApi.AiGatewayProviderConfigs` | `/provider_configs` list/create/update/delete | Manages gateway provider configs. |
| `CloudflareApi.ApiShieldApiDiscovery` | `/api_gateway/discovery` OpenAPI + operations patching | Wraps API Shield discovery management endpoints. |
| `CloudflareApi.ApiShieldEndpointManagement` | `/api_gateway/operations` CRUD and schema export | Manages API Shield endpoint definitions. |
| `CloudflareApi.ApiShieldSchemaValidation` | Schema validation zone/operation settings and user schemas | Covers Schema Validation 2.0 endpoints. |
| `CloudflareApi.ApiShieldSettings` | `/api_gateway/configuration` get/update | Zone-level configuration helper. |
| `CloudflareApi.AsnIntelligence` | `/intel/asn` overview + subnets | Provides ASN intel helpers. |
| `CloudflareApi.AccessBookmarks` | Deprecated bookmark application endpoints | Maintains legacy Access bookmark support. |
| `CloudflareApi.AccessScimUpdateLogs` | `/access/logs/scim/updates` list | Lists SCIM update logs for an account. |
| `CloudflareApi.AccessAppPolicies` | `/access/apps/:app_id/policies` | Manage app-scoped Access policies. |
| `CloudflareApi.AccessApplications` | `/access/apps` CRUD plus token/settings helpers | Full Access application management. |
| `CloudflareApi.AccessAuthenticationLogs` | `/access/logs/access_requests` list | Authentication log retrieval. |
| `CloudflareApi.AccessCustomPages` | `/access/custom_pages` CRUD | Manage Access custom pages. |
| `CloudflareApi.AccessGroups` | `/access/groups` CRUD | Manage Access groups. |
| `CloudflareApi.AccessIdentityProviders` | `/access/identity_providers` CRUD + SCIM | Identity provider management. |
| `CloudflareApi.AccessKeyConfiguration` | `/access/keys` get/update/rotate | Access key configuration helper. |
| `CloudflareApi.AccessMtlsAuthentication` | `/access/certificates` + settings | Manage mTLS certificates and settings. |
| `CloudflareApi.AccessPolicyTester` | `/access/policy-tests` | Run policy tests and retrieve results. |
| `CloudflareApi.AccessReusablePolicies` | `/access/policies` | Reusable policy CRUD. |
| `CloudflareApi.AccessServiceTokens` | `/access/service_tokens` | Manage service tokens, refresh, rotate. |
| `CloudflareApi.AccessShortLivedCertificateCas` | `/access/apps/:app_id/ca` | Short-lived certificate CA helpers. |
| `CloudflareApi.ApiShieldClientCertificates` | `/client_certificates` + hostname associations | Manage client certs for API Shield. |
| `CloudflareApi.ApiShieldWafExpressionTemplates` | `/expression-template/fallthrough` | Manage WAF expression templates. |
| `CloudflareApi.AccessTags` | `/access/tags` | Access tag CRUD.
| `CloudflareApi.Account` | `/accounts/:account_id/builds/account/limits` | Account limits helper. |
| `CloudflareApi.AccountBillingProfile` | `/accounts/:account_id/billing/profile` | Billing profile fetcher. |
| `CloudflareApi.AccountLoadBalancerMonitorGroups` | `/load_balancers/monitor_groups` | Monitor group CRUD + references. |
| `CloudflareApi.AccountLoadBalancerMonitors` | `/load_balancers/monitors` | Monitor CRUD, preview, references. |
| `CloudflareApi.AccountLoadBalancerPools` | `/load_balancers/pools` | Pool CRUD, health, preview, references. |
| `CloudflareApi.AccountLoadBalancerSearch` | `/load_balancers/search` | Resource search helper. |
| `CloudflareApi.AccountMembers` | `/accounts/:account_id/members` | Manage account members. |
| `CloudflareApi.AccountOwnedApiTokens` | `/accounts/:id/tokens` CRUD, verify, permission groups | Account-owned token helpers. |
| `CloudflareApi.AccountPermissionGroups` | `/iam/permission_groups` | List permission groups. |
| `CloudflareApi.AccountRequestTracer` | `/request-tracer/trace` | Trigger request tracer. |
| `CloudflareApi.AccountResourceGroups` | `/iam/resource_groups` | Resource group CRUD. |
| `CloudflareApi.AccountRoles` | `/accounts/:id/roles` | List account roles. |
| `CloudflareApi.AccountRulesets` | `/rulesets` CRUD, entrypoints, versions | Account ruleset helpers. |
| `CloudflareApi.AccountSubscriptions` | `/subscriptions` CRUD | Manage subscriptions. |
| `CloudflareApi.AccountUserGroups` | `/iam/user_groups` + members | User group management. |
| `CloudflareApi.AccountCustomNameservers` | `/custom_ns` + zone usage | Custom nameserver management. |
| `CloudflareApi.RealtimeKitActiveSession` | `/realtime/kit/.../active-session` | Manage meeting sessions. |
| `CloudflareApi.RealtimeKitAnalytics` | `/realtime/kit/:app_id/analytics/daywise` | Daywise analytics. |
| `CloudflareApi.RealtimeKitApps` | `/realtime/kit/apps` | Realtime Kit app CRUD. |
| `CloudflareApi.AnalyzeCertificate` | `/ssl/analyze` | Analyze zone certificates. |
| `CloudflareApi.ArgoAnalyticsGeolocation` | `/analytics/latency/colos` | Argo latency analytics. |
| `CloudflareApi.ArgoAnalyticsZone` | `/zones/:zone_id/analytics/latency` | Zone-level Argo analytics. |
| `CloudflareApi.ArgoSmartRouting` | `/zones/:zone_id/argo/smart_routing` | Toggle Smart Routing. |
| `CloudflareApi.Attacker` | `/cloudforce-one/events/attackers` | Cloudforce One attacker feed. |
| `CloudflareApi.AuditLogs` | `/audit_logs`, `/logs/audit`, `/user/audit_logs` | Account/user audit logs. |
| `CloudflareApi.AutoragJobs` | `/autorag/rags/:rag_id/jobs` | AutoRAG job listings/logs. |
| `CloudflareApi.AutoragRags` | `/autorag/rags` CRUD | Manage AutoRAG collections. |
| `CloudflareApi.AutoragRagSearch` | `/autorag/rags/:rag_id/search` | Execute AutoRAG search queries. |
| `CloudflareApi.AutomaticSslTls` | `/zones/:zone_id/settings/ssl_automatic_mode` | Automatic SSL/TLS enrollment. |
| `CloudflareApi.AvailablePageRulesSettings` | `/zones/:zone_id/pagerules/settings` | Page Rules settings metadata. |
| `CloudflareApi.BinDb` | `/accounts/:account_id/cloudforce-one/binary` | BinDB upload and fetch helpers. |
| `CloudflareApi.BotSettings` | `/zones/:zone_id/bot_management` | Manage zone bot settings. |
| `CloudflareApi.BotnetThreatFeed` | `/botnet_feed/...` ASN reports/configs | Botnet feed helpers. |
| `CloudflareApi.BuildTokens` | `/builds/tokens` | Manage build tokens. |
| `CloudflareApi.Builds` | `/builds/builds` | Build inspection/log helpers. |
| `CloudflareApi.Cnis` | `/cni/cnis` | CNI CRUD operations. |
| `CloudflareApi.CacheReserveClear` | `/smart_shield/cache_reserve_clear` | Cache Reserve Clear trigger/status. |
| `CloudflareApi.CallsApps` | `/calls/apps` | Calls app CRUD. |
| `CloudflareApi.CallsTurnKeys` | `/calls/turn_keys` | TURN key management. |
| `CloudflareApi.CatalogSync` | `/magic/cloud/catalog-syncs` | Catalog sync CRUD + refresh. |
| `CloudflareApi.CloudflareIps` | `/ips` | Cloudflare public IP ranges. |
| `CloudflareApi.CloudflareImages` | `/images/v1`, `/images/v2` | Cloudflare Images APIs. |
| `CloudflareApi.CloudflareImagesKeys` | `/images/v1/keys` | Images signing keys. |
| `CloudflareApi.CloudflareImagesVariants` | `/images/v1/variants` | Images variant CRUD. |
| `CloudflareApi.CloudflareTunnels` | `/cfd_tunnel`, `/warp_connector`, `/tunnels` | Tunnel CRUD/connectors. |
| `CloudflareApi.CloudflareTunnelConfiguration` | `/cfd_tunnel/:id/configurations` | Tunnel config management. |
| `CloudflareApi.ConnectivityServices` | `/connectivity/directory/services` | Connectivity directory APIs. |
| `CloudflareApi.ContentScanning` | `/content-upload-scan` | Content scanning controls. |
| `CloudflareApi.Country` | `/cloudforce-one/events/countries` | Country intel lookups. |
| `CloudflareApi.CustomHostnameFallbackOrigin` | `/custom_hostnames/fallback_origin` | Fallback origin settings. |
| `CloudflareApi.CustomHostnames` | `/custom_hostnames` | Zone custom hostnames + certs. |
| `CloudflareApi.CustomIndicatorFeeds` | `/intel/indicator-feeds` | Custom indicator feed APIs. |
| `CloudflareApi.CustomOriginTrustStore` | `/acm/custom_trust_store` | ACM custom trust stores. |
| `CloudflareApi.CustomSsl` | `/custom_certificates` | Custom SSL configs. |
| `CloudflareApi.CredentialManagement` | `/r2-catalog/:bucket_name/credential` | Store R2 catalog credentials. |
| `CloudflareApi.CustomPagesZone` | `/zones/:id/custom_pages` | Zone custom page management. |
| `CloudflareApi.CustomPagesAccount` | `/accounts/:id/custom_pages` | Account custom page management. |
| `CloudflareApi.D1` | `/d1/database` | Manage D1 databases/queries. |
| `CloudflareApi.DcvDelegation` | `GET /zones/:zone_id/dcv_delegation/uuid` | Retrieves the delegated DCV UUID for a zone. |
| `CloudflareApi.DexRemoteCommands` | `/dex/commands` list/create/devices/quota/download endpoints | Remote command CRUD helpers plus binary downloads. |
| `CloudflareApi.DexSyntheticApplicationMonitoring` | `/dex/colos`, `/dex/fleet-status/*`, `/dex/http-tests/*`, `/dex/traceroute-*` | Covers the Synthetic Monitoring analytics GET endpoints. |
| `CloudflareApi.DlpDatasets` | `/dlp/datasets` CRUD plus upload helpers | Handles dataset versions, column metadata, and binary uploads. |
| `CloudflareApi.DlpDocumentFingerprints` | `/dlp/document_fingerprints` CRUD + upload | Document fingerprint management and multipart uploads. |
| `CloudflareApi.DlpEmail` | `/dlp/email/account_mapping`, `/dlp/email/rules` | Email DLP account mapping and rule management. |
| `CloudflareApi.DlpEntries` | `/dlp/entries` list/create/get/update/delete | General entry CRUD including custom/predefined updates. |
| `CloudflareApi.DlpIntegrationEntries` | `/dlp/entries/integration` CRUD | Integration-entry lifecycle helpers. |
| `CloudflareApi.DlpPredefinedEntries` | `/dlp/entries/predefined` create/delete | Predefined entry helpers. |
| `CloudflareApi.DlpProfiles` | `/dlp/profiles` list/custom/predefined/config helpers | Full profile lifecycle coverage. |
| `CloudflareApi.DlpSettings` | `/dlp/limits`, `/dlp/patterns/validate`, `/dlp/payload_log` | Account-level settings helpers. |
| `CloudflareApi.DlsRegionalServices` | `/addressing/regional_hostnames` list/create/update/delete | Regional hostname management + region listings. |
| `CloudflareApi.DnsAnalytics` | `/dns_analytics/report` + `/bytime` | DNS analytics reports (table & time series). |
| `CloudflareApi.DnsFirewall` | `/dns_firewall` cluster CRUD + reverse DNS | DNS Firewall cluster management. |
| `CloudflareApi.DnsFirewallAnalytics` | `/dns_firewall/:id/dns_analytics` | Cluster analytics table + by time. |
| `CloudflareApi.DnsInternalViews` | `/dns_settings/views` CRUD | Internal view management for accounts. |
| `CloudflareApi.DnsSettings` | `/dns_settings` account + zone endpoints | DNS settings show/update. |
| `CloudflareApi.Dnssec` | `/zones/:zone_id/dnssec` get/update/delete | DNSSEC helpers. |
| `CloudflareApi.Dataset` | `/cloudforce-one/events/dataset` CRUD | Cloudforce One dataset management. |
| `CloudflareApi.Datasets` | `/cloudforce-one/events/datasets/populate` | Populate dataset lookup tables. |
| `CloudflareApi.Destinations` | `/workers/observability/destinations` CRUD | Workers observability destinations. |
| `CloudflareApi.DeviceDexTests` | `/dex/devices/dex_tests` CRUD | Device DEX test management. |
| `CloudflareApi.DeviceManagedNetworks` | `/devices/networks` CRUD | Managed network helpers. |
| `CloudflareApi.DevicePostureIntegrations` | `/devices/posture/integration` CRUD | Device posture integration helpers. |
| `CloudflareApi.DevicePostureRules` | `/devices/posture` CRUD | Device posture rule helpers. |
| `CloudflareApi.Devices` | `/devices` + settings policy endpoints | Device settings, overrides, certificates. |
| `CloudflareApi.DevicesResilience` | `/devices/resilience/disconnect` | Global WARP override management. |
| `CloudflareApi.Diagnostics` | `/diagnostics/traceroute` | Traceroute diagnostic helper. |
| `CloudflareApi.DomainHistory` | `/intel/domain-history` | Domain history lookups. |
| `CloudflareApi.DomainIntelligence` | `/intel/domain`, `/intel/domain/bulk` | Domain intelligence lookups. |
| `CloudflareApi.DurableObjectsNamespace` | `/workers/durable_objects/namespaces` list/objects | Durable Objects namespace helpers. |
| `CloudflareApi.EmailRoutingDestinationAddresses` | `/email/routing/addresses` CRUD | Email routing destination address management. |
| `CloudflareApi.EmailRoutingRoutingRules` | `/email/routing/rules` get/create/update/delete | Routing rule and catch-all helpers. |
| `CloudflareApi.EmailRoutingSettings` | `/email/routing` settings + DNS toggles | Email routing enable/disable + DNS helpers. |
| `CloudflareApi.EmailSecurity` | `/email-security/investigate` endpoints | Message investigation helpers. |
| `CloudflareApi.EmailSecuritySettings` | `/email-security/settings` | Allow/block/trusted domain settings. |
| `CloudflareApi.EndpointHealthChecks` | `/diagnostics/endpoint-healthchecks` CRUD | Endpoint health check helpers. |
| `CloudflareApi.EnvironmentVariables` | `/builds/triggers/:id/environment_variables` list/upsert/delete | Build trigger environment variables. |
| `CloudflareApi.Event` | `/cloudforce-one/events` CRUD + relationships/raw | Cloudforce One event helpers. |
| `CloudflareApi.Feedback` | `/bot_management/feedback` list/create | Bot management feedback. |
| `CloudflareApi.Filters` | `GET/POST/PUT/DELETE /zones/:zone_id/filters` + single filter operations | Bulk and single firewall filter CRUD with query helpers. |
| `CloudflareApi.FirewallRules` | `/zones/:zone_id/firewall/rules` list/create/update/delete + priority helpers | Bulk and single firewall rule management with delete + priority APIs. |
| `CloudflareApi.GatewayCa` | `/accounts/:account_id/access/gateway_ca` list/create/delete | SSH CA management for Access Gateway. |
| `CloudflareApi.GitHubIntegration` | `/builds/repos/.../config_autofill` | Repo config autofill helper for the GitHub integration. |
| `CloudflareApi.HealthChecks` | `/zones/:zone_id/healthchecks` + preview + Smart Shield variants | Full health check CRUD, preview helpers, and Smart Shield endpoints. |
| `CloudflareApi.Hyperdrive` | `/accounts/:account_id/hyperdrive/configs` CRUD | Hyperdrive configuration lifecycle helper. |
| `CloudflareApi.IpAccessRulesAccount` | `/accounts/:account_id/firewall/access_rules/rules` CRUD | Account-level IP access rule management. |
| `CloudflareApi.IpAccessRulesUser` | `/user/firewall/access_rules/rules` CRUD | User-level IP access rules. |
| `CloudflareApi.IpAccessRulesZone` | `/zones/:zone_id/firewall/access_rules/rules` CRUD | Zone-level IP access rules with cascade deletes. |
| `CloudflareApi.IpAddressManagementAddressMaps` | `/addressing/address_maps` CRUD + memberships | Address map management plus account/IP/zone membership helpers. |
| `CloudflareApi.IpAddressManagementBgpPrefixes` | `/addressing/prefixes/:id/bgp/prefixes` CRUD | BGP prefix lifecycle helpers. |
| `CloudflareApi.IpAddressManagementDynamicAdvertisement` | `/addressing/prefixes/:id/bgp/status` | Fetch and update dynamic advertisement state. |
| `CloudflareApi.IpAddressManagementLeases` | `/addressing/leases` list | Lease listing helper. |
| `CloudflareApi.IpAddressManagementPrefixDelegation` | `/addressing/prefixes/:id/delegations` CRUD | Manage prefix delegations to other accounts. |
| `CloudflareApi.IpAddressManagementPrefixes` | `/addressing/prefixes` CRUD + validate + LOA download | Prefix lifecycle, validation, and LOA download wrapper. |
| `CloudflareApi.IpAddressManagementServiceBindings` | `/addressing/prefixes/:id/bindings` CRUD + services | Service binding CRUD plus service catalog listing. |
| `CloudflareApi.IpIntelligence` | `/intel/ip` overview | IP reputation/overview helper. |
| `CloudflareApi.IpList` | `/intel/ip-list` | IP list metadata fetcher. |
| `CloudflareApi.Indicator` | `/cloudforce-one/events/dataset/:dataset/indicators` CRUD + global list | Dataset indicator management, bulk ops, and tag listing. |
| `CloudflareApi.IndicatorTypes` | Indicator type listing + creation endpoints | Handles modern/legacy list plus dataset type creation. |
| `CloudflareApi.InfrastructureAccessTargets` | `/infrastructure/targets` CRUD + batch | Target CRUD, batch ops, status, and LOA download. |
| `CloudflareApi.InstantLogsJobs` | `/logpush/edge/jobs` list/create | Instant Logs job management for zones. |
| `CloudflareApi.Interconnects` | `/cni/interconnects` CRUD + status + LOA | Network interconnect lifecycle helper incl. LOA download. |
| `CloudflareApi.KeylessSslZone` | `/zones/:zone_id/keyless_certificates` CRUD | Zone-level Keyless SSL configuration management. |
| `CloudflareApi.Keys` | `POST /accounts/:account_id/workers/observability/telemetry/keys` | Lists Workers Observability telemetry keys for an account. |
| `CloudflareApi.LeakedCredentialChecks` | `/zones/:zone_id/leaked-credential-checks` status + custom detection CRUD | Manage Leaked Credential Checks status and custom detection patterns. |
| `CloudflareApi.Lists` | `/accounts/:account_id/rules/lists` CRUD + items/bulk operations | Account filter list definitions, items, and async bulk operations. |
| `CloudflareApi.LiveStreams` | `/realtime/kit/.../livestreams` CRUD + meeting helpers | Covers Realtime Kit livestream CRUD, meeting controls, and stream key resets. |
| `CloudflareApi.LivestreamAnalytics` | `/analytics/livestreams` daywise + overall | Fetches livestream analytics aggregates with time filters. |
| `CloudflareApi.LoadBalancerHealthcheckEvents` | `GET /user/load_balancing_analytics/events` | Lists user-level healthcheck events with pool/origin filters. |
| `CloudflareApi.LoadBalancerMonitors` | `/user/load_balancers/monitors` CRUD + preview | User-level monitor lifecycle, previews, and references. |
| `CloudflareApi.LoadBalancerPools` | `/user/load_balancers/pools` CRUD + health/preview references | User-level pool management, bulk patch, health, and previews. |
| `CloudflareApi.LoadBalancerRegions` | `/accounts/:account_id/load_balancers/regions` list/get | Region mapping helpers for load balancers. |
| `CloudflareApi.LoadBalancers` | `/zones/:zone_id/load_balancers` CRUD | Zone-level load balancer configuration helpers. |
| `CloudflareApi.LogcontrolCmbConfig` | `/accounts/:account_id/logs/control/cmb/config` get/update/delete | Account-level CMB log control configuration. |
| `CloudflareApi.LogpushJobsZone` | `/zones/:zone_id/logpush` jobs + validation endpoints | Zone Logpush jobs, ownership challenges, destination/origin validation. |
| `CloudflareApi.LogpushJobsAccount` | `/accounts/:account_id/logpush` jobs + validation endpoints | Account Logpush jobs plus helper validations. |
| `CloudflareApi.LogsReceived` | `/zones/:zone_id/logs/*` retention flag + Logpull data | Zone log retention flag, Logpull data, RayID lookups, and field metadata. |
| `CloudflareApi.MagicAccountApps` | `/accounts/:account_id/magic/apps` CRUD | Manage Magic WAN account applications. |
| `CloudflareApi.MagicConnectors` | `/accounts/:account_id/magic/connectors` CRUD + telemetry | Connector management plus telemetry events/snapshots helpers. |
| `CloudflareApi.MagicGreTunnels` | `/accounts/:account_id/magic/gre_tunnels` CRUD + bulk update | GRE tunnel lifecycle helpers including batch update. |
| `CloudflareApi.MagicIpsecTunnels` | `/accounts/:account_id/magic/ipsec_tunnels` CRUD + PSK generation | IPsec tunnel management, bulk updates, and PSK generation. |
| `CloudflareApi.MagicNetworkMonitoringConfiguration` | `/accounts/:account_id/mnm/config` CRUD + full listing | Account-level MNM configuration helpers. |
| `CloudflareApi.MagicNetworkMonitoringRules` | `/accounts/:account_id/mnm/rules` CRUD + advertisement updates | MNM rule lifecycle management. |
| `CloudflareApi.MagicNetworkMonitoringVpcFlows` | `POST /accounts/:account_id/mnm/vpc-flows/token` | Generates VPC flow log auth tokens. |
| `CloudflareApi.MagicPcapCollection` | `/accounts/:account_id/pcaps` requests + bucket ownership | Manage PCAP capture requests and storage ownership. |
| `CloudflareApi.MagicSites` | `/accounts/:account_id/magic/sites` CRUD | Manage Magic Sites. |
| `CloudflareApi.MagicSiteAcls` | `/accounts/:account_id/magic/sites/:site_id/acls` CRUD | Site-level ACL management. |
| `CloudflareApi.MagicSiteAppConfigs` | `/accounts/:account_id/magic/sites/:site_id/app_configs` CRUD | Manage per-site app configs. |
| `CloudflareApi.MagicSiteLans` | `/accounts/:account_id/magic/sites/:site_id/lans` CRUD | Site LAN definitions. |
| `CloudflareApi.MagicSiteNetflowConfig` | `/accounts/:account_id/magic/sites/:site_id/netflow_config` CRUD | Site NetFlow configuration. |
| `CloudflareApi.MagicSiteWans` | `/accounts/:account_id/magic/sites/:site_id/wans` CRUD | Site WAN interfaces. |
| `CloudflareApi.MagicStaticRoutes` | `/accounts/:account_id/magic/routes` CRUD + bulk ops | Manage Magic static routes with validation helpers. |
| `CloudflareApi.MaintenanceConfiguration` | `/accounts/:account_id/r2-catalog/:bucket/maintenance-configs` get/update | R2 catalog maintenance configuration helper. |
| `CloudflareApi.ManagedTransforms` | `/zones/:zone_id/managed_headers` list/update/delete | Managed header transform controls. |
| `CloudflareApi.Meetings` | `/accounts/:account_id/realtime/kit/:app_id/meetings` CRUD + participants | Realtime Kit meeting and participant APIs. |
| `CloudflareApi.Miscategorization` | `POST /accounts/:account_id/intel/miscategorization` | Submit intel miscategorization reports. |
| `CloudflareApi.NamespaceManagement` | `/accounts/:account_id/r2-catalog/:bucket/namespaces` list | List R2 catalog namespaces. |
| `CloudflareApi.McpPortal` | `GET/POST/GET/PUT/DELETE /accounts/:account_id/access/ai-controls/mcp/portals` | Manage Access AI Controls portals. |
| `CloudflareApi.McpPortalServers` | `/accounts/:account_id/access/ai-controls/mcp/servers` list/create/get/update/delete + `/sync` | MCP server CRUD plus capability sync trigger. |
| `CloudflareApi.MagicInterconnects` | `/accounts/:account_id/magic/cf_interconnects` list/bulk update/get/update | Covers interconnect listing and updates. |
| `CloudflareApi.NotificationAlertTypes` | `GET /accounts/:account_id/alerting/v3/available_alerts` | Lists available alert types. |
| `CloudflareApi.NotificationHistory` | `GET /accounts/:account_id/alerting/v3/history` | Alert delivery history listing. |
| `CloudflareApi.NotificationMechanismEligibility` | `GET /accounts/:account_id/alerting/v3/destinations/eligible` | Delivery mechanism eligibility helper. |
| `CloudflareApi.NotificationSilences` | `/accounts/:account_id/alerting/v3/silences` list/create/update/get/delete | Silence CRUD operations. |
| `CloudflareApi.NotificationDestinationsPagerduty` | `/accounts/:account_id/alerting/v3/destinations/pagerduty` list/delete + `/connect` token endpoints | PagerDuty destination management & connect helper. |
| `CloudflareApi.NotificationPolicies` | `/accounts/:account_id/alerting/v3/policies` list/create/get/update/delete | Notification policy lifecycle. |
| `CloudflareApi.NotificationWebhooks` | `/accounts/:account_id/alerting/v3/destinations/webhooks` list/create/get/update/delete | Manage webhook destinations. |
| `CloudflareApi.Observatory` | `/zones/:zone_id/speed_api/*` for availabilities/pages/tests/schedules | Speed (Observatory) listings, test management, and scheduling. |
| `CloudflareApi.OnRamps` | `/accounts/:account_id/magic/cloud/onramps` CRUD + apply/plan/export + Magic WAN address space | Magic WAN on-ramp lifecycle helpers. |
| `CloudflareApi.OrganizationMembers` | `/organizations/:organization_id/members` list/create/get/delete + batch create | Organization member management. |
| `CloudflareApi.Organizations` | `/organizations` list/create/get/update/delete + accounts/profile | Organization CRUD plus account & profile helpers. |
| `CloudflareApi.OriginCa` | `/certificates` list/create/get/delete | Origin CA certificate lifecycle. |
| `CloudflareApi.OriginPostQuantum` | `/zones/:zone_id/cache/origin_post_quantum_encryption` get/update | Manage Origin Post-Quantum encryption setting. |
| `CloudflareApi.PageRules` | `/zones/:zone_id/pagerules` list/create/get/update/patch/delete | Page Rule lifecycle helpers. |
| `CloudflareApi.PageShield` | `/zones/:zone_id/page_shield` settings + connections/cookies/policies/scripts | Page Shield settings, policy, and signal accessors. |
| `CloudflareApi.PagesBuildCache` | `POST /accounts/:account_id/pages/projects/:project/purge_build_cache` | Purge Pages build cache. |
| `CloudflareApi.PagesDeployments` | `/accounts/:account_id/pages/projects/:project/deployments` list/create/get/delete/logs/retry/rollback | Pages deployment lifecycle helpers. |
| `CloudflareApi.PassiveDnsByIp` | `GET /accounts/:account_id/intel/dns` | Passive DNS lookups scoped to an account. |
| `CloudflareApi.PerHostnameTlsSettings` | `/zones/:zone_id/hostnames/settings/:setting_id` list/get/put/delete | Manage per-hostname TLS overrides. |
| `CloudflareApi.PerHostnameAuthenticatedOriginPull` | `/zones/:zone_id/origin_tls_client_auth/hostnames` + certificates | Configure hostname auth origin pull and client certificates. |
| `CloudflareApi.PhysicalDevices` | `/accounts/:account_id/devices/physical-devices` list/get/delete/revoke + registrations | Physical device lifecycle helpers. |
| `CloudflareApi.Presets` | `/accounts/:account_id/realtime/kit/:app_id/presets` list/create/get/update/delete | Realtime Kit preset management. |
| `CloudflareApi.PriorityIntelligenceRequirements` | `/accounts/:account_id/cloudforce-one/requests/priority*` | Cloudforce One PIR CRUD, quotas, and listings. |
| `CloudflareApi.TelemetryQuery` | `POST /accounts/:account_id/workers/observability/telemetry/query` | Run Workers observability queries. |
| `CloudflareApi.Queues` | `/event_subscriptions/subscriptions` + `/queues` + consumers/messages/purge | Full queue, subscription, consumer, and message helpers. |
| `CloudflareApi.R2Account` | `GET /accounts/:account_id/r2/metrics` | Account-level R2 metrics fetcher. |
| `CloudflareApi.R2Bucket` | `/accounts/:account_id/r2/buckets` + domains/cors/lifecycle/event notifications/temp creds | Comprehensive R2 bucket management. |
| `CloudflareApi.R2CatalogManagement` | `/accounts/:account_id/r2-catalog` list/get + enable/disable | Manage R2 cataloging state per bucket. |
| `CloudflareApi.R2SuperSlurper` | `/accounts/:account_id/slurper/*` job CRUD + connectivity checks | Super Slurper job lifecycle helpers. |
| `CloudflareApi.RadarAiBots` | `/radar/ai/bots/*` summary/timeseries endpoints | AI bot analytics wrappers. |
| `CloudflareApi.RadarAiInference` | `/radar/ai/inference/*` summary/timeseries endpoints | AI inference analytics helpers. |
| `CloudflareApi.RadarAs112` | `/radar/as112/*` summary/timeseries/top endpoints | AS112 analytics (timeseries + top locations). |
| `CloudflareApi.RadarAnnotations` | `/radar/annotations*` list/outage endpoints | Radar annotation listings. |
| `CloudflareApi.RadarAutonomousSystems` | `/radar/entities/asns*` list/get/as-set/rel | ASN metadata lookups. |
| `CloudflareApi.RadarBgp` | `/radar/bgp/*` metrics/events routes | BGP events, routes, and top listings. |
| `CloudflareApi.RadarBots` | `/radar/bots*` overview/summary/timeseries/bot detail | Radar bot analytics helper. |
| `CloudflareApi.RadarCertificateTransparency` | `/radar/ct/*` authorities/logs/summary/timeseries | Certificate transparency analytics. |
| `CloudflareApi.RadarDns` | `/radar/dns/*` summary/timeseries/top endpoints | DNS analytics summary, grouping, and top listings. |
| `CloudflareApi.RadarDatasets` | `/radar/datasets*` list/get/download | Dataset listing + download URL helper. |
| `CloudflareApi.RadarDomainsRanking` | `/radar/ranking/*` domain ranking endpoints | Domain rank top/time-series lookups. |
| `CloudflareApi.RadarEmailRouting` | `/radar/email/routing/*` summary/timeseries groups | Email routing analytics helpers. |
| `CloudflareApi.RadarEmailSecurity` | `/radar/email/security/*` summary/timeseries/top tlds | Email security analytics incl. top TLDs. |
| `CloudflareApi.RadarGeolocations` | `/radar/geolocations*` list/get | Radar geolocation metadata. |
| `CloudflareApi.RadarHttp` | `/radar/http/*` summary/timeseries/top endpoints | HTTP analytics across dimensions. |
| `CloudflareApi.RadarIp` | `GET /radar/entities/ip` | Single IP metadata lookup. |
| `CloudflareApi.RadarInternetServicesRanking` | `/radar/ranking/internet_services/*` categories/top/timeseries | Internet services ranking analytics. |
| `CloudflareApi.RadarLayer3Attacks` | `/radar/attacks/layer3/*` summary/timeseries/top endpoints | Layer 3 attack analytics. |
| `CloudflareApi.RadarLayer7Attacks` | `/radar/attacks/layer7/*` summary/timeseries/top endpoints | Layer 7 attack analytics helpers. |
| `CloudflareApi.RadarLeakedCredentialChecks` | `/radar/leaked_credential_checks/*` summary/timeseries | Leaked credential check analytics. |
| `CloudflareApi.RadarLocations` | `/radar/entities/locations*` list/detail | Location metadata lookups. |
| `CloudflareApi.RadarNetflows` | `/radar/netflows/*` summary/timeseries/top endpoints | NetFlows analytics endpoints. |
| `CloudflareApi.RadarOrigins` | `/radar/origins/*` list/summary/timeseries | Origin analytics + detail fetchers. |
| `CloudflareApi.RadarQuality` | `/radar/quality/*` IQI + speed analytics | Quality index and speed analytics wrappers. |
| `CloudflareApi.RadarRobotsTxt` | `/radar/robots_txt/top/*` endpoints | Robots.txt top user agents/domain categories. |
| `CloudflareApi.RadarSearch` | `GET /radar/search/global` | Radar global search helper. |
| `CloudflareApi.RadarTcpResetsTimeouts` | `/radar/tcp_resets_timeouts/*` summary/timeseries | TCP resets/timeouts analytics. |
| `CloudflareApi.RadarTopLevelDomains` | `/radar/tlds*` list/detail | Top-level domain metadata. |
| `CloudflareApi.RadarTrafficAnomalies` | `/radar/traffic_anomalies*` list + locations | Traffic anomaly listings and top locations. |
| `CloudflareApi.RadarVerifiedBots` | `/radar/verified_bots/top/*` endpoints | Verified bot analytics. |
| `CloudflareApi.RadarWebCrawlers` | `/radar/bots/crawlers/*` summary/timeseries | Web crawler analytics. |
| `CloudflareApi.RateLimits` | `/zones/:zone_id/rate_limits` list/create/get/update/delete | Zone rate limit lifecycle helper. |
| `CloudflareApi.Recordings` | `/accounts/:account_id/realtime/kit/:app_id/recordings*` | Realtime Kit recording management. |
| `CloudflareApi.RegistrarDomains` | `/accounts/:account_id/registrar/domains` list/get/update | Registrar domain helpers. |
| `CloudflareApi.Registrations` | `/accounts/:account_id/devices/registrations` list/get/delete + revoke/unrevoke | Device registration management. |
| `CloudflareApi.RepositoryConnections` | `/accounts/:account_id/builds/repos/connections` upsert/delete | Builds repo connection helpers. |
| `CloudflareApi.RequestForInformation` | `/accounts/:account_id/cloudforce-one/requests*` | Cloudforce One RFI lifecycle, assets, and messages. |
| `CloudflareApi.ResourceSharing` | `/accounts/:account_id/shares*` + org shares | Share, recipient, and resource management. |
| `CloudflareApi.ResourcesCatalog` | `/accounts/:account_id/magic/cloud/resources` list/export/policy-preview/get | Magic Cloud resource catalog helpers. |
| `CloudflareApi.SslVerification` | `/zones/:zone_id/ssl/verification*` | SSL verification details + pack updates. |
| `CloudflareApi.SslTlsModeRecommendation` | `GET /zones/:zone_id/ssl/recommendation` | Fetches SSL/TLS mode recommendation. |
| `CloudflareApi.SsoConnectors` | `/accounts/:account_id/sso_connectors*` list/create/get/update/delete | Account SSO connector management inc. verification. |
| `CloudflareApi.Scans` | `/accounts/:account_id/cloudforce-one/scans/*` | Cloudforce One scan config CRUD + results. |
| `CloudflareApi.SchemaValidation` | `/zones/:zone_id/schema_validation/schemas*` | Schema validation schema CRUD + host/operation extraction. |
| `CloudflareApi.SchemaValidationSettings` | `/zones/:zone_id/schema_validation/settings*` | Zone schema validation settings + per-operation overrides. |
| `CloudflareApi.SecondaryDnsAcl` | `/accounts/:account_id/secondary_dns/acls*` | Secondary DNS ACL lifecycle helpers. |
| `CloudflareApi.SecondaryDnsPeer` | `/accounts/:account_id/secondary_dns/peers*` | Secondary DNS peer management. |
| `CloudflareApi.SecondaryDnsPrimaryZone` | `/zones/:zone_id/secondary_dns/outgoing*` | Primary zone (outgoing) configuration helpers. |
| `CloudflareApi.PagesDomains` | `/accounts/:account_id/pages/projects/:project_name/domains` GET/POST/PATCH/DELETE | Manage Pages custom domain lifecycle. |
| `CloudflareApi.PagesProject` | `/accounts/:account_id/pages/projects` + `/:project_name` GET/POST/PATCH/DELETE | Pages project list/create/get/update/delete. |
| `CloudflareApi.SecondaryDnsSecondaryZone` | `/zones/:zone_id/secondary_dns/incoming` CRUD + `/force_axfr` | Incoming secondary zone config + forced transfers. |
| `CloudflareApi.SecondaryDnsTsig` | `/accounts/:account_id/secondary_dns/tsigs` list/create/get/update/delete | TSIG key management for Secondary DNS. |
| `CloudflareApi.SecretsStore` | `/accounts/:account_id/secrets_store/*` quota, stores, and secrets endpoints | Secrets Store quota plus store/secret CRUD + duplicate helpers. |
| `CloudflareApi.SecurityCenterInsights` | `/intel/attack-surface-report/*`, `/security-center/insights*` (account+zone) | Security Center insight listings, counts, and dismissals. |
| `CloudflareApi.Sessions` | `/accounts/:account_id/realtime/kit/:app_id/sessions*` list/session/participants/chat/summary/transcript | Realtime Kit session and participant analytics. |
| `CloudflareApi.Settings` | `GET/PUT /accounts/:account_id/cni/settings` | Magic WAN / Magic Transit account settings helper. |
| `CloudflareApi.SinkholeConfig` | `GET /accounts/:account_id/intel/sinkholes` | Account sinkhole configuration listing. |
| `CloudflareApi.Slots` | `/accounts/:account_id/cni/slots` list + `/slots/:slot` detail | Slot inventory lookup helpers. |
| `CloudflareApi.SmartShieldSettings` | `GET/PATCH /zones/:zone_id/smart_shield` | Smart Shield zone-level settings helper. |
| `CloudflareApi.SmartTieredCache` | `/zones/:zone_id/cache/tiered_cache_smart_topology_enable` GET/PATCH/DELETE | Smart Tiered Cache configuration management. |
| `CloudflareApi.SpectrumAnalytics` | `/zones/:zone_id/spectrum/analytics/*` aggregate/current, by time, summary | Spectrum analytics listing helpers. |
| `CloudflareApi.SpectrumApplications` | `/zones/:zone_id/spectrum/apps` list/create/get/update/delete | Spectrum application lifecycle helper. |
| `CloudflareApi.StreamAudioTracks` | `/accounts/:account_id/stream/:identifier/audio*` | Manage Stream video audio tracks. |
| `CloudflareApi.StreamLiveInputs` | `/accounts/:account_id/stream/live_inputs*` + outputs | Stream live input + output management. |
| `CloudflareApi.StreamMp4Downloads` | `/accounts/:account_id/stream/:identifier/downloads*` | Manage MP4 downloads (all + type-specific) for videos. |
| `CloudflareApi.StreamSigningKeys` | `/accounts/:account_id/stream/keys` list/create/delete | Stream signing key helpers. |
| `CloudflareApi.StreamSubtitlesCaptions` | `/accounts/:account_id/stream/:identifier/captions*` | Manage Stream subtitles/captions upload/download. |
| `CloudflareApi.StreamVideoClipping` | `POST /accounts/:account_id/stream/clip` | Clip Stream videos via start/end time. |
| `CloudflareApi.StreamVideos` | `/accounts/:account_id/stream*` list/upload/update/delete/embed/token | Core Stream video lifecycle helper. |
| `CloudflareApi.StreamWatermarkProfile` | `/accounts/:account_id/stream/watermarks*` | Stream watermark profile CRUD. |
| `CloudflareApi.StreamWebhook` | `/accounts/:account_id/stream/webhook` GET/PUT/DELETE | Manage Stream webhook endpoints. |
| `CloudflareApi.TableMaintenanceConfiguration` | `/r2-catalog/.../tables/:table/maintenance-configs` GET/POST | R2 catalog table maintenance config helper. |
| `CloudflareApi.TableManagement` | `/r2-catalog/.../tables` list | List tables within an R2 namespace. |
| `CloudflareApi.Tag` | `/cloudforce-one/events/tags*` + dataset indicators | Cloudforce One tag CRUD + indicator listing. |
| `CloudflareApi.TagCategory` | `/cloudforce-one/events/tags/categories*` | Cloudforce One tag category CRUD. |
| `CloudflareApi.TargetIndustry` | `/cloudforce-one/events/targetIndustries*` + dataset variants | Target-industry listings per dataset/catalog. |
| `CloudflareApi.Tenants` | `/tenants/:tenant_id/*` detail + accounts/types/entitlements/memberships | Tenant metadata helper. |
| `CloudflareApi.TieredCaching` | `/zones/:zone_id/argo/tiered_caching` GET/PATCH | Argo Tiered Caching configuration helper. |
| `CloudflareApi.TokenValidationTokenConfiguration` | `/zones/:zone_id/token_validation/config*` | Token Validation config CRUD + credential updates. |
| `CloudflareApi.TokenValidationTokenRules` | `/zones/:zone_id/token_validation/rules*` list/create/bulk/update/delete/preview | Token Validation rule lifecycle helper. |
| `CloudflareApi.TotalTls` | `/zones/:zone_id/acm/total_tls` GET/POST | Total TLS setting management. |
| `CloudflareApi.Triggers` | `/accounts/:account_id/builds/triggers*` + manual builds/cache purge | Build trigger CRUD + helpers. |
| `CloudflareApi.TunnelRouting` | `/accounts/:account_id/teamnet/routes*` list/create/update/delete + IP lookups | Tunnel route management. |
| `CloudflareApi.TunnelVirtualNetwork` | `/accounts/:account_id/teamnet/virtual_networks*` | Virtual network CRUD. |
| `CloudflareApi.Turnstile` | `/accounts/:account_id/challenges/widgets*` | Turnstile widget CRUD + secret rotation. |
| `CloudflareApi.UrlNormalization` | `/zones/:zone_id/url_normalization` GET/PUT/DELETE | URL normalization setting helper. |
| `CloudflareApi.UrlScanner` | `/accounts/:account_id/urlscanner/v2/*` scan/search/dom/har/screenshot/response | Modern URL Scanner v2 helpers. |
| `CloudflareApi.UrlScannerDeprecated` | `/accounts/:account_id/urlscanner/*` scan/search/har/screenshot/response | Legacy URL Scanner helpers.
| `CloudflareApi.UniversalSslSettings` | `/zones/:zone_id/ssl/universal/settings` GET/PATCH | Universal SSL setting helper. |
| `CloudflareApi.User` | `/user` GET/PATCH + `/users/tenants` list | Authenticated user profile + tenant listing. |
| `CloudflareApi.UserApiTokens` | `/user/tokens*` list/create/update/delete/verify/permission groups | User API token management.
| `CloudflareApi.UserAgentBlockingRules` | `/zones/:zone_id/firewall/ua_rules*` | Zone UA blocking rule CRUD. |
| `CloudflareApi.UserBillingHistory` | `GET /user/billing/history` | User billing history fetcher. |
| `CloudflareApi.UserBillingProfile` | `GET /user/billing/profile` | User billing profile helper. |
| `CloudflareApi.UserSubscription` | `/user/subscriptions*` list/update/delete | User subscription management. |
| `CloudflareApi.UserAccountMemberships` | `/memberships*` list/get/update/delete | User account membership helper. |
| `CloudflareApi.UsersInvites` | `/user/invites*` list/get/respond | User invitation management. |
| `CloudflareApi.UsersOrganizations` | `/user/organizations*` list/get/delete | User organization membership helper.
| `CloudflareApi.Values` | `POST /accounts/:account_id/workers/observability/telemetry/values` | Workers telemetry values listing. |
| `CloudflareApi.Vectorize` | `/accounts/:account_id/vectorize/v2/indexes*` CRUD + vector ops | Vectorize v2 index/vector management. |
| `CloudflareApi.VectorizeBeta` | `/accounts/:account_id/vectorize/indexes*` (deprecated) | Legacy Vectorize beta helper. |
| `CloudflareApi.Versions` | `/accounts/:account_id/workers/workers/:worker_id/versions*` | Workers version list/create/get/delete. |
| `CloudflareApi.WafOverrides` | `/zones/:zone_id/firewall/waf/overrides*` | Zone WAF override CRUD. |
| `CloudflareApi.WafPackages` | `/zones/:zone_id/firewall/waf/packages*` | WAF package list/get/update. |
| `CloudflareApi.WafRuleGroups` | `/zones/:zone_id/firewall/waf/packages/:package_id/groups*` | Rule group list/get/update. |
| `CloudflareApi.WafRules` | `/zones/:zone_id/firewall/waf/packages/:package_id/rules*` | Rule list/get/update. |
| `CloudflareApi.WarpChangeEvents` | `GET /accounts/:account_id/dex/warp-change-events` | WARP change event listing. |
| `CloudflareApi.WaitingRoom` | `/waiting_rooms` account+zone listings, CRUD, events, rules, preview, settings, status | Full Waiting Room management surface. |
| `CloudflareApi.WebAnalytics` | `/rum/site_info`, `/rum/v2/:ruleset_id/(rule|rules)`, `/zones/:zone_id/settings/rum` | Web Analytics site/rule CRUD plus zone RUM toggles. |
| `CloudflareApi.Web3Hostname` | `/web3/hostnames*` + IPFS universal path content list entries | Web3 hostname CRUD and IPFS gateway content lists. |
| `CloudflareApi.Webhooks` | `/realtime/kit/:app_id/webhooks*` | Realtime Kit webhook list/create/get/update/replace/delete. |
| `CloudflareApi.WorkerAccountSettings` | `/accounts/:account_id/workers/account-settings` GET/PUT | Worker account settings fetch/update helper. |
| `CloudflareApi.WorkerCronTrigger` | `/workers/scripts/:script_name/schedules` GET/PUT | Worker cron schedule listing and replacement. |
| `CloudflareApi.WorkerDeployments` | `/workers/scripts/:script_name/deployments*` | Worker deployment list/create/get/delete with optional `force`. |
| `CloudflareApi.WorkerDomain` | `/accounts/:account_id/workers/domains*` | Domain listing, attach, get, and detach helpers. |
| `CloudflareApi.WorkerEnvironment` | `/workers/services/:service/environments/:environment` content/settings | Environment content upload + settings patch helpers. |
| `CloudflareApi.WorkerScript` | `/accounts/:account_id/workers/scripts*` | Script list/search, uploads, settings, secrets, subdomains, usage model. |
| `CloudflareApi.WorkerSubdomain` | `/accounts/:account_id/workers/subdomain` GET/PUT/DELETE | Account-level Workers subdomain helper. |
| `CloudflareApi.WorkerTailLogs` | `/workers/scripts/:script_name/tails*` | Tail session list/start/delete. |
| `CloudflareApi.Workers` | `/accounts/:account_id/workers/workers*` + builds/triggers | Workers services CRUD plus build/trigger listings. |
| `CloudflareApi.WorkersAi` | `/accounts/:account_id/ai/*` | Workers AI author/model/task search, run, and markdown conversion endpoints. |
| `CloudflareApi.WorkersAiAutomaticSpeechRecognition` | `/ai/run/@cf/deepgram/*`, `/ai/run/@cf/openai/whisper*` | Automatic speech recognition websocket + run endpoints. |
| `CloudflareApi.WorkersAiDumbPipe` | `/ai/run/@cf/pipecat-ai/*` | Pipecat smart turn websocket helpers. |
| `CloudflareApi.WorkersAiFinetune` | `/ai/finetunes*` | Finetune list/create/public listing + asset uploads. |
| `CloudflareApi.WorkersAiImageClassification` | `/ai/run/@cf/microsoft/resnet-50` | Image classification runner. |
| `CloudflareApi.WorkersAiObjectDetection` | `/ai/run/@cf/facebook/omni-detr-resnet-50` | Object detection runner. |
| `CloudflareApi.WorkersAiSummarization` | `/ai/run/@cf/facebook/(omni-)?bart-large-cnn` | Summarization model runners. |
| `CloudflareApi.WorkersAiTextClassification` | `/ai/run/@cf/(baai|huggingface)/*` | Text classification model runners. |
| `CloudflareApi.WorkersAiTextEmbeddings` | `/ai/run/@cf/(baai|google|pfnet|qwen)/*` | Text embedding model runners. |
| `CloudflareApi.WorkersAiTextGeneration` | `/ai/run/@cf|@hf/*` | Text generation/run endpoints for OSS/partner models. |
| `CloudflareApi.WorkersAiTextToImage` | `/ai/run/@cf/*` + websocket test pipe | Text-to-image runs plus websocket helper. |
| `CloudflareApi.WorkersAiTextToSpeech` | `/ai/run/@cf/(deepgram|myshell-ai)/*` | TTS run + websocket endpoints. |
| `CloudflareApi.WorkersAiTranslation` | `/ai/run/@cf/(ai4bharat|meta)/*` | Translation helpers. |
| `CloudflareApi.WorkersKvNamespace` | `/storage/kv/namespaces*` + keys/bulk/values | Namespace management and key/value CRUD. |
| `CloudflareApi.WorkersForPlatforms` | `/workers/dispatch/namespaces*` | Workers for Platforms namespace/script lifecycle helpers. |
| `CloudflareApi.Workflows` | `/accounts/:account_id/workflows*` | Workflow definitions, instances, events, and versions. |
| `CloudflareApi.Zaraz` | `/zones/:zone_id/settings/zaraz/*` | Zaraz zone config, workflow, publish, and history endpoints. |
| `CloudflareApi.ZeroTrustConnectivitySettings` | `/accounts/:account_id/zerotrust/connectivity_settings` GET/PATCH | Zero Trust connectivity settings helper. |
| `CloudflareApi.ZeroTrustGatewayPacFiles` | `/accounts/:account_id/gateway/pacfiles` | PAC file list/create helpers. |
| `CloudflareApi.ZeroTrustGatewayAppTypeMappings` | `/accounts/:account_id/gateway/app_types` | Application/application-type mapping list helper. |
| `CloudflareApi.ZeroTrustGatewayCategories` | `/accounts/:account_id/gateway/categories` | Gateway category listing helper. |
| `CloudflareApi.ZeroTrustGatewayLocations` | `/accounts/:account_id/gateway/locations*` | Gateway location list/create/get/update/delete. |
| `CloudflareApi.ZeroTrustGatewayProxyEndpoints` | `/gateway/proxy_endpoints*` | Proxy endpoint list/create/get/update/delete. |
| `CloudflareApi.ZeroTrustGatewayRules` | `/gateway/rules*` | Zero Trust Gateway rule CRUD + tenant listing + expiration reset. |
| `CloudflareApi.ZeroTrustHostnameRoute` | `/zerotrust/routes/hostname*` | Hostname route list/create/get/update/delete. |
| `CloudflareApi.ZeroTrustRiskScoring` | `/zt_risk_scoring` behaviors/summary/user/reset | Risk scoring behavior + summary + user reset helpers. |
| `CloudflareApi.ZeroTrustRiskScoringIntegrations` | `/zt_risk_scoring/integrations*` | Integration list/create/update/delete + reference lookup. |
| `CloudflareApi.ZeroTrustSshSettings` | `/gateway/audit_ssh_settings*` | SSH audit settings get/update/rotate seed. |
| `CloudflareApi.ZeroTrustSubnets` | `/zerotrust/subnets*` | Subnet listing plus Cloudflare source updates. |
| `CloudflareApi.ZeroTrustAccounts` | `/devices/settings`, `/gateway`, `/gateway/configuration`, `/gateway/logging` | Device settings + Zero Trust account info/config/logging helpers. |
| `CloudflareApi.ZeroTrustApplicationsReviewStatus` | `/gateway/apps/review_status` GET/PUT | Review status fetch/update. |
| `CloudflareApi.ZeroTrustCertificates` | `/gateway/certificates*` | Certificate list/create/get/delete + activate/deactivate. |
| `CloudflareApi.ZeroTrustLists` | `/gateway/lists*` + `/items` | Zero Trust list CRUD and item listing. |
| `CloudflareApi.ZeroTrustOrganization` | `/access/organizations*` + DoH + revoke user | Organization CRUD + DoH + token revocation. |
| `CloudflareApi.ZeroTrustSeats` | `/access/seats` PATCH | Zero Trust seat updates. |
| `CloudflareApi.ZeroTrustUsers` | `/access/users*` | Zero Trust user listing plus active session, failed login, and last-seen lookups. |
| `CloudflareApi.ZoneAnalyticsDeprecated` | `/zones/:zone_id/analytics/dashboard`, `/analytics/colos` | Deprecated analytics dashboard and colo helpers. |
| `CloudflareApi.ZoneCacheSettings` | `/zones/:zone_id/cache/*` | Cache reserve, reserve clear, regional tiered cache, and variants endpoints. |
| `CloudflareApi.ZoneCloudConnectorRules` | `/zones/:zone_id/cloud_connector/rules` GET/PUT | Cloud Connector rule retrieval and replacement. |
| `CloudflareApi.ZoneHolds` | `/zones/:zone_id/hold` GET/POST/PATCH/DELETE | Zone hold lifecycle management. |
| `CloudflareApi.WhoisRecord` | `GET /accounts/:account_id/intel/whois` | WHOIS record lookup helper. |

## Remaining Modules

The following OpenAPI tags still require dedicated modules. When you begin work
on one, move it to the “Completed Modules” table above (and include any notes).

- Diagnostics
- Domain History
- Domain Intelligence
- Durable Objects Namespace
- Email Routing destination addresses
- Email Routing routing rules
- Email Routing settings
- Email Security
- Email Security Settings
- Endpoint Health Checks
- Environment Variables
- Event
- Feedback
- Zone Lockdown
- Zone Rate Plan
- Zone Rulesets
- Zone Settings
- Zone Snippets
- Zone Subscription
- Zone-Level Access applications
- Zone-Level Access groups
- Zone-Level Access identity providers
- Zone-Level Access mTLS authentication
- Zone-Level Access policies
- Zone-Level Access service tokens
- Zone-Level Access short-lived certificate CAs
- Zone-Level Authenticated Origin Pulls
- Zone-Level Zero Trust organization
- brand_protection
- brapi
- domain_search
- dos-flowtrackd-api_other
- logo_match
- mTLS Certificate Management
- ppc_config
- ppc_stripe
- security.txt
- tseng-abuse-complaint-processor_other
- warp-teams-device-api_other
- workers_pipelines_other

## Working Notes

- Tests should live under `test/cloudflare_api/<module>_test.exs` and rely on
  `Tesla.Mock` with example responses that mirror the OpenAPI envelope.
- Avoid regenerating modules automatically; everything should be explicit and
  easy to audit.
- If you discover a spec ambiguity, record it in this file so the next person
  knows why an endpoint was implemented a certain way.
