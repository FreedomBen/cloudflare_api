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

## Remaining Modules

The following OpenAPI tags still require dedicated modules. When you begin work
on one, move it to the “Completed Modules” table above (and include any notes).

- Cloudflare IPs
- Cloudflare Images
- Cloudflare Images Keys
- Cloudflare Images Variants
- Cloudflare Tunnel
- Cloudflare Tunnel Configuration
- Connectivity Services
- Content Scanning
- Country
- Credential Management
- Custom Hostname Fallback Origin for a Zone
- Custom Hostname for a Zone
- Custom Indicator Feeds
- Custom Origin Trust Store
- Custom SSL for a Zone
- Custom pages for a zone
- Custom pages for an account
- D1
- DCV Delegation
- DEX Remote Commands
- DEX Synthetic Application Monitoring
- DLP Datasets
- DLP Document Fingerprints
- DLP Email
- DLP Entries
- DLP Integration Entries
- DLP Predefined Entries
- DLP Profiles
- DLP Settings
- DLS Regional Services
- DNS Analytics
- DNS Firewall
- DNS Firewall Analytics
- DNS Internal Views for an Account
- DNS Settings for a Zone
- DNS Settings for an Account
- DNSSEC
- Dataset
- Datasets
- Destinations
- Device DEX Tests
- Device Managed Networks
- Device Posture Integrations
- Device posture rules
- Devices
- Devices Resilience
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
- Filters
- Firewall rules
- Gateway CA
- GitHub Integration
- Health Checks
- Hyperdrive
- IP Access rules for a user
- IP Access rules for a zone
- IP Access rules for an account
- IP Address Management Address Maps
- IP Address Management BGP Prefixes
- IP Address Management Dynamic Advertisement
- IP Address Management Leases
- IP Address Management Prefix Delegation
- IP Address Management Prefixes
- IP Address Management Service Bindings
- IP Intelligence
- IP List
- Indicator
- Indicator Types
- Indicators
- Infrastructure Access Targets
- Instant Logs jobs for a zone
- Interconnects
- Keyless SSL for a Zone
- Keys
- Leaked Credential Checks
- Lists
- Live streams
- LivestreamAnalytics
- Load Balancer Healthcheck Events
- Load Balancer Monitors
- Load Balancer Pools
- Load Balancer Regions
- Load Balancers
- Logcontrol CMB config for an account
- Logpush jobs for a zone
- Logpush jobs for an account
- Logs Received
- MCP Portal
- MCP Portal Servers
- Magic Account Apps
- Magic Connectors
- Magic GRE tunnels
- Magic IPsec tunnels
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
