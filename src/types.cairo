use starknet::StorageAccess;
use starknet::StorageBaseAddress;
use starknet::SyscallResult;
use starknet::storage_write_syscall;
use starknet::storage_read_syscall;
use starknet::storage_address_from_base_and_offset;

#[derive(Drop, Serde)]
struct NounAdj {
    noun: felt252,
    adj: felt252
}

impl StorageAccessNounAdj of StorageAccess::<NounAdj> {
    fn read(address_domain: u32, base: StorageBaseAddress) -> SyscallResult<NounAdj> {
        Result::Ok(
            NounAdj {
                noun: storage_read_syscall(
                    address_domain, storage_address_from_base_and_offset(base, 0_u8)
                )?,
                adj: storage_read_syscall(
                    address_domain, storage_address_from_base_and_offset(base, 1_u8)
                )?
            }
        )
    }
    #[inline(always)]
    fn write(address_domain: u32, base: StorageBaseAddress, value: NounAdj) -> SyscallResult<()> {
        storage_write_syscall(
            address_domain, storage_address_from_base_and_offset(base, 0_u8), value.noun
        )?;
        storage_write_syscall(
            address_domain, storage_address_from_base_and_offset(base, 1_u8), value.adj
        )
    }
}
