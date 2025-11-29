# Full API Implementation Progress

This log tracks manual, hand-written implementations of the Cloudflare API
operations described in `FULL_API_IMPLEMENTATION_PLAN.md`. Modules are grouped
roughly by the OpenAPI tag they represent.

## Completed Modules

| Module | Endpoints Covered | Notes |
| --- | --- | --- |
| `CloudflareApi.DnsRecords` | `GET/POST/PUT/DELETE /zones/:zone/dns_records` plus helpers | Legacy handwritten module, aligned with OpenAPI spec. |
| `CloudflareApi.Zones` | `GET /zones` | Returns raw zone maps; relies on `opts` keyword list for filters. |
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
- MCP Portal
- MCP Portal Servers
- Magic Interconnects
- Magic Network Monitoring Configuration
- Magic Network Monitoring Rules
- Magic Network Monitoring VPC Flow logs
- Magic PCAP collection
- Magic Site ACLs
- Magic Site App Configs
- Magic Site LANs
- Magic Site NetFlow Config
- Magic Site WANs
- Magic Sites
- Magic Static Routes
- Maintenance Configuration
- Managed Transforms
- Meetings
- Miscategorization
- Namespace Management
- Notification Alert Types
- Notification History
- Notification Mechanism Eligibility
- Notification Silences
- Notification destinations with PagerDuty
- Notification policies
- Notification webhooks
- Observatory
- On-ramps
- OrganizationMembers
- Organizations
- Origin CA
- Origin Post-Quantum
- Page Rules
- Page Shield
- Pages Build Cache
- Pages Deployment
- Pages Domains
- Pages Project
- Passive DNS by IP
- Per-Hostname TLS Settings
- Per-hostname Authenticated Origin Pull
- Physical Devices
- Presets
- Priority Intelligence Requirements (PIR)
- Query run
- Queue
- R2 Account
- R2 Bucket
- R2 Catalog Management
- R2 Super Slurper
- Radar AI Bots
- Radar AI Inference
- Radar AS112
- Radar Annotations
- Radar Autonomous Systems
- Radar BGP
- Radar Bots
- Radar Certificate Transparency
- Radar DNS
- Radar Datasets
- Radar Domains Ranking
- Radar Email Routing
- Radar Email Security
- Radar Geolocations
- Radar HTTP
- Radar IP
- Radar Internet Services Ranking
- Radar Layer 3 Attacks
- Radar Layer 7 Attacks
- Radar Leaked Credential Checks
- Radar Locations
- Radar NetFlows
- Radar Origins
- Radar Quality
- Radar Robots.txt
- Radar Search
- Radar TCP Resets and Timeouts
- Radar Top-Level Domains
- Radar Traffic Anomalies
- Radar Verified Bots
- Radar Web Crawlers
- Rate limits for a zone
- Recordings
- Registrar Domains
- Registrations
- Repository Connections
- Request for Information (RFI)
- Resource Sharing
- Resources
- SSL Verification
- SSL/TLS Mode Recommendation
- SSO
- Scans
- Schema Validation
- Schema Validation Settings
- Secondary DNS (ACL)
- Secondary DNS (Peer)
- Secondary DNS (Primary Zone)
- Secondary DNS (Secondary Zone)
- Secondary DNS (TSIG)
- Secrets Store
- Security Center Insights
- Sessions
- Settings
- Sinkhole Config
- Slots
- Smart Shield Settings
- Smart Tiered Cache
- Spectrum Analytics
- Spectrum Applications
- Stream Audio Tracks
- Stream Live Inputs
- Stream MP4 Downloads
- Stream Signing Keys
- Stream Subtitles/Captions
- Stream Video Clipping
- Stream Videos
- Stream Watermark Profile
- Stream Webhook
- Table Maintenance Configuration
- Table Management
- Tag
- TagCategory
- Target Industry
- Tenants
- Tiered Caching
- Token Validation Token Configuration
- Token Validation Token Rules
- Total TLS
- Triggers
- Tunnel Routing
- Tunnel Virtual Network
- Turnstile
- URL Normalization
- URL Scanner
- URL Scanner (Deprecated)
- Universal SSL Settings for a Zone
- User
- User API Tokens
- User Agent Blocking rules
- User Billing History
- User Billing Profile
- User Subscription
- User's Account Memberships
- User's Invites
- User's Organizations
- Values
- Vectorize
- Vectorize Beta (Deprecated)
- Versions
- WAF overrides
- WAF packages
- WAF rule groups
- WAF rules
- WARP Change Events
- WHOIS Record
- Waiting Room
- Web Analytics
- Web3 Hostname
- Webhooks
- Worker Account Settings
- Worker Cron Trigger
- Worker Deployments
- Worker Domain
- Worker Environment
- Worker Script
- Worker Subdomain
- Worker Tail Logs
- Worker Versions
- Workers
- Workers AI
- Workers AI Automatic Speech Recognition
- Workers AI Dumb Pipe
- Workers AI Finetune
- Workers AI Image Classification
- Workers AI Object Detection
- Workers AI Summarization
- Workers AI Text Classification
- Workers AI Text Embeddings
- Workers AI Text Generation
- Workers AI Text To Image
- Workers AI Text To Speech
- Workers AI Translation
- Workers KV Namespace
- Workers for Platforms
- Workflows
- Zaraz
- Zero Trust Connectivity Settings
- Zero Trust Gateway PAC files
- Zero Trust Gateway application and application type mappings
- Zero Trust Gateway categories
- Zero Trust Gateway locations
- Zero Trust Gateway proxy endpoints
- Zero Trust Gateway rules
- Zero Trust Hostname Route
- Zero Trust Risk Scoring
- Zero Trust Risk Scoring Integrations
- Zero Trust SSH Settings
- Zero Trust Subnets
- Zero Trust accounts
- Zero Trust applications review status
- Zero Trust certificates
- Zero Trust lists
- Zero Trust organization
- Zero Trust seats
- Zero Trust users
- Zone
- Zone Analytics (Deprecated)
- Zone Cache Settings
- Zone Cloud Connector Rules GET
- Zone Cloud Connector Rules PUT
- Zone Holds
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
